---
name: Invoke `wiki ask` proactively — don't ask the user to run it
description: When the user asks anything that touches the Work Obsidian vault, Claude runs `wiki ask` itself via Bash and uses the answer; never punt to the user
type: feedback
---

When the user asks anything that could be answered from their Work Obsidian vault (`~/Dropbox/Notes/Obsidian Vault/Work/`), **invoke `wiki ask "..."` yourself via the Bash tool** and use the grounded answer to respond. Do NOT tell the user "you can run `wiki ask`" — that defeats the purpose.

**Why:** The user pointed out (2026-05-25) that the whole point of the `wiki` CLI is to save them from running individual queries — having them run `wiki ask` manually wastes their time AND tokens (round-trips through me to reformulate what the CLI already produced). They installed it so I would use it.

**How to apply:**

- Default behavior: any "what does my note say about X", "how is Y configured in my work", "remind me what the plan was for Z" → run `wiki ask "..."` first, then answer.
- Multi-question conversations: still use one-shot `wiki ask` per question. Do NOT spawn `wiki chat` — that's interactive REPL, only useful for the human user directly.
- Token-frugal: don't run `wiki moc` (~80–150K tokens) or `wiki enrich` (per-note LLM calls) without the user explicitly asking. Those are intentional, expensive operations.
- Keep raw `wiki ask` output out of the chat unless the user wants citations — summarize the relevant part and reference the cited `[[Note Title]]` so they can open it in Obsidian if they want.
- If `wiki ask` returns nothing useful, fall back to reading specific notes directly. But always try the CLI first.

**Anti-pattern to avoid:**
- "You can run `wiki ask 'foo'` to find out" → No. Run it yourself, share the result.
- Repeatedly reading individual `.md` files when a single `wiki ask` could answer in one call.
