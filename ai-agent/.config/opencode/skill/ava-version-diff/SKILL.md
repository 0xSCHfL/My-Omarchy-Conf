---
name: ava-version-diff
description: |-
  Compare upstream AVA version (hkjarral/AVA-AI-Voice-Agent-for-Asterisk) with the user's fork (0xSCHfL/AVA-AI-Voice-Agent-for-Asterisk) to find what files changed and what modifications were made. Read-only — does NOT modify any files. Use proactively when user asks about AVA updates, new features, version comparison, or what changed between versions.

  Examples:
  - user: "Check what's new in the latest AVA version" → run comparison script, report changed files and modifications
  - user: "Compare my fork with upstream AVA" → fetch upstream, diff, summarize
  - user: "What files changed since last sync?" → show file-level diff summary
  - user: "Show me the diff with upstream AVA" → display detailed modification report
  - user: "Which files are my custom features?" → list protected custom files
---

# AVA Version Diff

Read-only comparison between upstream AVA and user's fork.

## What This Does

1. Fetches latest from upstream (`hkjarral/AVA-AI-Voice-Agent-for-Asterisk`)
2. Compares AVA-relevant directories (`src/`, `admin_ui/`, `config/`, `docker-compose*.yml`) with user's current branch
3. Reports what files changed, what was added/modified/deleted
4. **NEVER modifies anything** — pure read-only comparison

## Setup

Remote repos are already configured:
- `upstream` → `https://github.com/hkjarral/AVA-AI-Voice-Agent-for-Asterisk.git`
- `origin` → `https://github.com/0xSCHfL/AVA-AI-Voice-Agent-for-Asterisk.git`

If remotes don't exist, run:
```bash
git remote add upstream https://github.com/hkjarral/AVA-AI-Voice-Agent-for-Asterisk.git
```

## Custom Features (DO NOT MODIFY)

**IMPORTANT**: Before syncing with upstream, always read `CUSTOM_FEATURES.md` in the repo root to see which files are custom and should not be overwritten.

```bash
cat CUSTOM_FEATURES.md
```

## Usage

### Quick diff (recommended)

```bash
python3 ~/.config/opencode/skill/ava-version-diff/scripts/ava_diff.py
```

This runs the full comparison and outputs a report.

### Manual steps (if script fails)

1. Fetch latest upstream:
   ```bash
   git fetch upstream
   ```

2. Find the divergence point:
   ```bash
   git merge-base HEAD upstream/main
   ```

3. List changed files:
   ```bash
   git diff --stat <merge-base>..upstream/main -- src/ admin_ui/ config/ docker-compose*.yml
   ```

4. Show detailed diffs per file:
   ```bash
   git diff <merge-base>..upstream/main -- <file-path>
   ```

## Output

The script produces:
- **Summary**: total files changed, additions, deletions
- **File list**: each file with change type (added/modified/deleted)
- **Per-file details**: what specifically changed (functions, classes, config keys)
- **Nothing is modified** — purely read-only

## Notes

- The script auto-fetches from upstream before comparing
- Only compares AVA-relevant directories (skips personal configs like dwm/, i3/, etc.)
- If the user's branch has diverged significantly, it shows the merge-base
- Python 3.9+ compatible (server constraint)
- Custom features documented in `CUSTOM_FEATURES.md` in repo root
