---
name: obsidian-wiki CLI tool
description: User's custom LLM-RAG CLI over the Work Obsidian vault — use it (or its underlying index) instead of grepping notes manually
type: reference
---

The user has a custom Python CLI at `~/Dropbox/obsidian-wiki/` (package `obsidian_wiki`, command `wiki`) that does LLM-grounded Q&A and MOC generation over the Work Obsidian vault. Prefer `wiki ask` over manually grepping `.md` files when answering questions about the user's notes.

## How to use

```sh
wiki status                      # vault path, note/chunk counts, pending changes
wiki ask "free-form question"    # one-shot RAG answer with [[wikilink]] citations
wiki chat                        # interactive REPL (interactive — only for the user, not for Claude to invoke)
wiki index [--force]             # rebuild BM25 index (incremental via sha1; cheap)
wiki moc                         # regenerate _wiki/MOCs/ + _wiki/concepts/ (~80-150K tokens; user-triggered only)
wiki enrich [folder]             # propose wikilinks/tags → staging dir
wiki review                      # diff-review each staged change (interactive)
```

LLM backend is configured for the Gemini CLI via the generic `cli` backend.

## Layout

- Source (Dropbox-synced): `~/Dropbox/obsidian-wiki/` — Python package, `pyproject.toml`, README.
- Machine-local data: `~/.local/share/obsidian-wiki/` — `venv/` + `index/` (notes.json, chunks.json, hashes.json) + `staging/`. Not synced — re-create per machine.
- Generated wiki output: `~/Dropbox/Notes/Obsidian Vault/Work/_wiki/` — fully regeneratable; safe to delete.
- Launcher: `~/.local/bin/wiki` — shell stub calling the venv binary.
- Shared cross-PC backend env: `~/Dropbox/claude-shared/obsidian-wiki/env` — preferred shared config.
- Local override env: `~/.config/obsidian-wiki/env` — optional per-machine override.

## Setup on a new machine

```sh
mkdir -p ~/.local/share/obsidian-wiki ~/.local/bin ~/.config/obsidian-wiki
cd ~/Dropbox/obsidian-wiki
UV_PROJECT_ENVIRONMENT=~/.local/share/obsidian-wiki/venv uv sync
cp ~/Work/dotfiles/i3/.config/obsidian-wiki/env.example ~/.config/obsidian-wiki/env.example
cat > ~/.config/obsidian-wiki/env <<'EOF'
export WIKI_BACKEND=cli
export WIKI_BACKEND_NAME=gemini
export WIKI_BACKEND_CMD='gemini -p {prompt} --output-format text'
export WIKI_LLM_TIMEOUT=300
# export GEMINI_API_KEY='replace-me'   # if needed on this machine
EOF
chmod 600 ~/.config/obsidian-wiki/env
wiki index
```

If cross-PC sync is desired, keep the real config in `~/Dropbox/claude-shared/obsidian-wiki/env` and use `~/.config/obsidian-wiki/env` only for machine-specific overrides.

Requires `uv` and the `gemini` CLI on PATH.

## Caveats / things to remember

- Never delete `_wiki/` thinking it's unused. It is regeneratable by `wiki moc`, but deleting it casually can remove useful generated navigation.
- Use `wiki ask` to discover content rather than guessing paths.
- `wiki moc` is expensive — only run it when the user explicitly asks for it.
- `wiki enrich` writes proposals to a staging dir; the user must run `wiki review` to actually apply them. Don't apply enrichments silently.
- `_wiki/` folder structure when populated: `_wiki/index.md` + `_wiki/MOCs/<project>.md` + `_wiki/concepts/<concept>.md`. Each gets `type: moc` frontmatter.
