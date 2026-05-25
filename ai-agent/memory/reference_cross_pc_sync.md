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
# 1) Symlink live Claude memory → Dropbox-shared location
LOCAL_MEM="$HOME/.claude/projects/-home-sohaib-Work-dotfiles/memory"
DROPBOX_MEM="$HOME/Dropbox/claude-shared/dotfiles/memory"
[ -d "$LOCAL_MEM" ] && ! [ -L "$LOCAL_MEM" ] && mv "$LOCAL_MEM" "${LOCAL_MEM}.backup-$(date +%s)"
mkdir -p "$(dirname "$LOCAL_MEM")"
ln -s "$DROPBOX_MEM" "$LOCAL_MEM"

# 2) Enable the daily git-snapshot timer (assumes dotfiles repo is at ~/Work/dotfiles)
UNIT_SRC="$HOME/Work/dotfiles/ai-agent/.config/systemd/user"
UNIT_DST="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DST"
ln -sf "$UNIT_SRC/memory-snapshot.service" "$UNIT_DST/memory-snapshot.service"
ln -sf "$UNIT_SRC/memory-snapshot.timer"   "$UNIT_DST/memory-snapshot.timer"
systemctl --user daemon-reload
systemctl --user enable --now memory-snapshot.timer
systemctl --user list-timers memory-snapshot.timer --no-pager
```

## Snapshot infrastructure (committed to dotfiles repo)

The dotfiles repo contains the snapshot script + systemd unit files (commit `cc7ceec`):

- `ai-agent/snapshot-memory.sh` — rsyncs `$HOME/Dropbox/claude-shared/dotfiles/memory/` into `ai-agent/memory/` and commits if anything changed (scoped commit — never sweeps up other dirty files).
- `ai-agent/.config/systemd/user/memory-snapshot.{service,timer}` — daily at 22:00 +5min random.
- `ai-agent/memory/` — committed snapshot. Pure data, regenerable from the live Dropbox source. Safe to delete and regenerate.

Run `~/Work/dotfiles/ai-agent/snapshot-memory.sh` manually any time to force a snapshot.

## Caveats / things to watch

- The Claude project name `-home-sohaib-Work-dotfiles` is derived from the cwd path `/home/sohaib/Work/dotfiles`. If the dotfiles repo lives at a different path on the home PC, the project name will differ and the symlink target won't match. Verify with `ls ~/.claude/projects/` on the home PC.
- Removed `_wiki/` from the Work vault on 2026-05-25 — it was a stale RAG-index folder belonging to the user's `obsidian-wiki` CLI (regeneratable via `wiki moc`; see separate memory).
- Dropbox may briefly show conflicts if both PCs write memory at the same time. Mitigation: don't run two simultaneous Claude Code sessions on the same project.
- **`cronie.service` was enabled on the work PC on 2026-05-25** as part of an initial (later abandoned) cron-based snapshot setup. We switched to a systemd user timer instead. cronie is now enabled but unused — safe to disable with `sudo systemctl disable --now cronie.service` if the user doesn't need it for anything else. Also: `/usr/bin/crontab` on the work PC has wrong ownership (`sohaib:sohaib` instead of `root:root`) and is missing setuid; that's why crontab fails for the user. Worth fixing only if they want cron later.
