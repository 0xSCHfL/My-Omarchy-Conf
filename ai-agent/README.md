# AI agent shared config

This package is the shared cross-PC configuration layer for the user's AI agents.

## Hermes design

Shared across PCs:
- `~/.hermes/config.yaml`
- `~/.hermes/.env`
- `~/.hermes/auth.json`
- `~/.hermes/active_profile`
- `~/.hermes/profiles/work-default/config.yaml`
- `~/.hermes/profiles/work-default/profile.yaml`
- `~/.hermes/profiles/work-default/.env`
- custom shared Hermes skills from `ai-agent/hermes-shared/skills/`

The stow package that links those Hermes files lives under:
- `ai-agent/hermes/.hermes/`

Local per PC only:
- `~/.hermes/state.db`
- `~/.hermes/sessions/`
- `~/.hermes/logs/`
- caches, locks, temporary runtime files
- local memory/session runtime artifacts

## Why custom Hermes skills are repo-only

Hermes writes runtime metadata inside `~/.hermes/skills/` such as usage and bundled manifests.
To avoid conflicts, shared custom skills live in this repo-only path instead:

- `/home/sohaib/Work/dotfiles/ai-agent/hermes-shared/skills`

Both shared Hermes config files add that path to:

- `skills.external_dirs`

This means both PCs load the same custom skills without syncing Hermes runtime files.

## Current shared custom skills

- `software-development/ava-project-workflow`
- `autonomous-ai-agents/cross-pc-agent-config-sync`

## Install / restow

From the dotfiles repo root:

```bash
./install.sh stow ai-agent
```

Or as part of the full install:

```bash
./install.sh stow all
```

## Verify

```bash
readlink -f ~/.hermes/config.yaml
readlink -f ~/.hermes/profiles/work-default/config.yaml
hermes profile show work-default
hermes skills list | grep -E 'ava-project-workflow|cross-pc-agent-config-sync'
```

## Notes

- The dotfiles repo is the source of truth for shared Hermes configuration.
- The preferred default profile is `work-default` via `~/.hermes/active_profile`.
- Do not put `state.db`, `sessions/`, or `logs/` into the shared layer.
