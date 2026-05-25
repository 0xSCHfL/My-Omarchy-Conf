---
name: Cross-PC sync setup (work + home)
description: How Claude Code memory and Obsidian notes are shared between the user's work and home PCs via Dropbox
type: reference
---

The user runs Claude Code on **two machines** (work PC + home PC) and wants continuity between them. Sync is done entirely via Dropbox.

## What syncs automatically (via Dropbox)

- **Obsidian Work vault**: `~/Dropbox/Notes/Obsidian Vault/Work/` — all `.md` notes, daily notes, project folders.
- **Claude Code memory**: lives at `~/Dropbox/claude-shared/dotfiles/memory/` (the real location), symlinked from `~/.claude/projects/-home-sohaib-Work-dotfiles/memory`. Any memory I write through the normal path lands in Dropbox and reaches the other PC.

## What does NOT sync (yet)

- Claude Code conversation transcripts (`*.jsonl` files in `~/.claude/projects/-home-sohaib-Work-dotfiles/`). They live only on each machine. Sharing them is possible but risks Dropbox sync conflicts because they're appended to constantly while in use.
- Dotfiles repo: synced via git (`~/Work/dotfiles`), not Dropbox.

## Home-PC setup (commands to give the user when on home PC)

```sh
LOCAL_MEM="$HOME/.claude/projects/-home-sohaib-Work-dotfiles/memory"
DROPBOX_MEM="$HOME/Dropbox/claude-shared/dotfiles/memory"

# Back up any existing local memory just in case
[ -d "$LOCAL_MEM" ] && ! [ -L "$LOCAL_MEM" ] && mv "$LOCAL_MEM" "${LOCAL_MEM}.backup-$(date +%s)"

# Symlink local memory path → Dropbox shared location
mkdir -p "$(dirname "$LOCAL_MEM")"
ln -s "$DROPBOX_MEM" "$LOCAL_MEM"

# Verify
ls -la "$LOCAL_MEM"
cat "$LOCAL_MEM/MEMORY.md"
```

## Caveats / things to watch

- The Claude project name `-home-sohaib-Work-dotfiles` is derived from the cwd path `/home/sohaib/Work/dotfiles`. If the dotfiles repo lives at a different path on the home PC, the project name will differ and the symlink target won't match. Verify with `ls ~/.claude/projects/` on the home PC.
- Removed `_wiki/` from the Work vault on 2026-05-25 — it was a stale RAG-index folder, not part of the sync strategy.
- Dropbox may briefly show conflicts if both PCs write memory at the same time. Mitigation: don't run two simultaneous Claude Code sessions on the same project.
