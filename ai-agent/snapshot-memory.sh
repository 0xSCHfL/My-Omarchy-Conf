#!/usr/bin/env bash
# Mirror the live Claude Code memory (in Dropbox) into the dotfiles repo as a
# committable snapshot, so memory evolution is preserved in git history.
#
# Source of truth for runtime: ~/Dropbox/claude-shared/dotfiles/memory/
# This script syncs FROM source -> ai-agent/memory/ and commits if changed.
#
# Run on a schedule (cron or systemd timer) or manually. Safe to run any time;
# does nothing when there are no changes.

set -euo pipefail

SRC="$HOME/Dropbox/claude-shared/dotfiles/memory"
REPO="$HOME/Work/dotfiles"
DEST="$REPO/ai-agent/memory"

[ -d "$SRC" ] || { echo "snapshot-memory: source missing: $SRC" >&2; exit 1; }
mkdir -p "$DEST"

rsync -a --delete --exclude='.DS_Store' "$SRC/" "$DEST/"

cd "$REPO"
git add "ai-agent/memory"
if git diff --cached --quiet -- "ai-agent/memory"; then
    # Nothing to commit.
    exit 0
fi

git commit -m "chore(ai-agent): memory snapshot $(date -u +%Y-%m-%dT%H:%MZ)" --quiet -- "ai-agent/memory"
echo "snapshot-memory: committed memory snapshot"
