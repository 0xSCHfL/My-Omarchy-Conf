---
name: obsidian-wiki
description: >
  Answer questions grounded in the user's Work Obsidian vault (AI voice agent
  "AVA" / Vocallremote, Callexpat / VICIdial, Hyphen-Dev-2026, server notes,
  daily logs) by calling the `wiki` CLI for RAG search with citations. Use
  whenever the user asks about their work projects, infrastructure, voice
  agent architecture, VICIdial setup, server configs, or their personal work
  notes. Also use to propose wikilink/tag enrichments on existing notes (always
  with a per-note review step — never edits silently). Triggers on phrases
  like: "what do my notes say about X", "how does AVA do Y", "ask the wiki",
  "search my work notes", "what did I write about the Callexpat backup", "find
  in my Obsidian", "check my vault for", "enrich the AVA notes", "add wikilinks
  to my notes". Do not use this skill for vocabulary, daily notes, music
  translation, budget, or web clipping — those have their own obsidian-*
  skills.
---

# Obsidian Wiki Skill

A Claude-facing wrapper around the `wiki` CLI at `~/.local/bin/wiki`. This skill exists so any Claude session can answer questions about the user's Work Obsidian vault (`~/Dropbox/Notes/Obsidian Vault/Work`) with grounded, cited answers — without you having to read the vault by hand.

## When to use this skill

Use it whenever the user's question touches their Work vault. Examples:

- "What STT providers does AVA support?"
- "How is the Callexpat backup configured?"
- "Where do I document Scaleway?"
- "Find the architecture diagram for the engine"
- "What's in my Hyphen-Dev notes?"
- "Enrich the AVA folder with wikilinks"

Do NOT use this skill for:
- Vocabulary → use `obsidian-vocab`
- Daily notes → use `obsidian-daily-notes`
- Music lyrics → use `obsidian-music-translate`
- Web page clipping → use `obsidian-clip`
- Budget → use `obsidian-budget`

If the question has nothing to do with the user's notes (general programming, news, etc.), do not invoke this skill — answer directly.

## Read-only Q&A — the default mode

For any question that needs grounding in the vault, run:

```bash
wiki ask "<the user's question, paraphrased into a clear standalone question>"
```

Behavior:
- The CLI does BM25 retrieval over the indexed vault, sends the top hits to the LLM (Claude via the `claude` CLI by default — no API key needed), and returns an answer that ends with `Sources: [[Note Title]], [[Other Note]]`.
- Treat that output as authoritative grounding. Pass the answer through to the user (you can format/clarify, but do not drop the citations — they let the user click straight to the source note in Obsidian).

Phrasing the query:
- Rewrite the user's message into a standalone, content-rich question. E.g. user says "remind me about the providers in AVA" → run `wiki ask "What providers does the AVA voice agent support, and how are they categorized?"`.
- Quote the question with double quotes; escape any internal double quotes.

Multi-turn:
- For follow-ups in the same session, send another `wiki ask "..."` each time. Each call is independent (no server-side conversation memory). If continuity matters, fold relevant prior context into the new query.

If `wiki ask` returns "No matching notes found" or "Vault not indexed yet":
- "Vault not indexed yet" → tell the user and offer to run `wiki index` (this is the one case where running index is appropriate — bootstrapping).
- "No matching notes" → say so honestly. Don't fabricate an answer from outside the vault. Optionally suggest the user reword or that the topic might genuinely not be in the vault.

## Staleness signal

If the user just told you they edited or created notes and now wants to ask about them, suggest running `wiki index` once before the query (it's incremental — only a second or two for unchanged notes). Don't auto-run it on every query.

```bash
wiki index   # only when notes have changed since last index
```

## Enrichment mode — propose wikilinks/tags with review

When the user asks to "enrich", "cross-link", "add wikilinks to", or "add tags to" notes in a specific folder, use the two-step flow. **Never skip the review step** — the user explicitly chose review-gated edits.

### Step 1: propose

```bash
wiki enrich "Projects/Project Vocallremote AVA"
```

- The folder argument is vault-relative. Use the exact folder name including spaces (quote it).
- Omitting the folder enriches the entire vault — costly. Confirm with the user before doing this.
- Output prints `proposed N note(s); skipped M`. Each proposed change is written to `~/.local/share/obsidian-wiki/staging/` — nothing in the vault has changed yet.

### Step 2: review interactively

```bash
wiki review
```

This is an **interactive TTY command** with `y/n/q` prompts per note. It will not work cleanly under your normal Bash tool invocation (no real stdin). Do one of:

1. **Recommended:** tell the user "I've proposed N changes — run `wiki review` in your terminal to walk through them, accepting or rejecting each." Stop there. Don't try to drive the review yourself.
2. If the user explicitly wants you to drive the review, list the staged files first (`ls ~/.local/share/obsidian-wiki/staging/`), then for each one read both the original (in the vault) and the staged version, present a diff in chat, and ask the user y/n. Apply accepted ones by copying staged → vault and `rm` the staged file. Reject by deleting the staged file. This is more work but possible.

## Safety properties to respect

- Never write to the vault outside the `wiki review` flow. Specifically: do not run `Edit` / `Write` on notes inside `~/Dropbox/Notes/Obsidian Vault/Work/` to add wikilinks yourself — that's what `wiki enrich` is for.
- `~/Dropbox/Notes/Obsidian Vault/Work/_wiki/` is auto-generated content. You can read it, but don't hand-edit it — it'll be overwritten by `wiki moc`.
- The vault folder names with spaces (e.g. `Project Vocallremote AVA`) must be quoted in shell calls.

## Project background — useful when phrasing queries

- **AVA / Vocallremote** (`Projects/Project Vocallremote AVA/`) — Python AI voice agent for Asterisk; STT/LLM/TTS pipelines, multiple full-agent providers (OpenAI Realtime, Google Live, Deepgram, ElevenLabs), MCP integration, admin UI.
- **Callexpat** (`Projects/Projects Callexpat/`) — VoIP / call-center ops; VICIdial setup, Rocket.chat / Mattermost servers, backups, security, customization.
- **Hyphen-Dev-2026** (`Projects/Hyphen-Dev-2026/`) — Scaleway cloud workstations, Guacamole, team onboarding.
- **Notes/servers/** — infra notes (vocallremote, crm-hg).
- **Notes/dailies/YYYY/MM/** — daily work logs.

Knowing the folder hierarchy helps you target `wiki enrich <folder>` precisely and rewrite vague user questions into concrete ones.

## Reference

- CLI source: `~/Dropbox/obsidian-wiki/` (also see its `README.md` for internals).
- Launcher: `~/.local/bin/wiki` → `~/.local/share/obsidian-wiki/venv/bin/wiki`.
- LLM backend: defaults to the `claude` CLI (subscription auth, no API key). Configurable via `WIKI_BACKEND` env var.
- Index location: `~/.local/share/obsidian-wiki/index/` (machine-local, not synced).
