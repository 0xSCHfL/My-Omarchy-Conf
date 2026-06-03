# Hermes dotfiles layout and shared-skill pattern

This reference captures a clean pattern for sharing Hermes across personal machines without sharing runtime state.

## Working layout

Use a dedicated Hermes Stow package inside the user's broader AI-agent dotfiles area, for example:

- `ai-agent/hermes/.hermes/`
- `ai-agent/hermes-shared/skills/`

This keeps Hermes separate from Claude/Codex/OpenCode files and avoids broad-package Stow conflicts.

## Shared files linked into ~/.hermes

Share and symlink these stable files:

- `config.yaml`
- `.env`
- `auth.json`
- `active_profile`
- `profiles/<profile>/config.yaml`
- `profiles/<profile>/profile.yaml`
- `profiles/<profile>/.env`

## Keep local in ~/.hermes

Do not sync:

- `state.db`
- `sessions/`
- `logs/`
- `runtime/`
- cache/lock/temp artifacts

## Shared custom skills

A strong pattern is to keep user-authored custom skills outside the live `~/.hermes/skills` tree and load them through config:

```yaml
skills:
  external_dirs:
    - /path/to/dotfiles/ai-agent/hermes-shared/skills
```

Benefits:

- custom skills travel with dotfiles cleanly
- the live `~/.hermes` tree stays smaller
- local runtime files stay local
- you can manage shared skills in git without forcing the whole Hermes home to be shared

## Migration steps

1. Back up existing live `~/.hermes` config/profile/auth files.
2. If local custom skills already exist, move them to a timestamped backup first.
3. Copy the chosen shared skills into the repo-owned shared skills directory.
4. Update both root and profile Hermes configs to include `skills.external_dirs`.
5. Stow or symlink the shared config files into `~/.hermes`.
6. Verify Hermes can load one of the shared custom skills.

## Important pitfall

If `stow ai-agent` collides with pre-existing non-Hermes files, do not force it. Split Hermes into a narrower package such as `ai-agent/hermes` and stow that package specifically.

## Verification checklist

- `~/.hermes/config.yaml` is a symlink into dotfiles
- profile files are symlinked into dotfiles
- `state.db`, `sessions/`, and `logs/` remain local
- Hermes can load a custom skill from `skills.external_dirs`
- plain `hermes` starts with the expected default profile on both machines
