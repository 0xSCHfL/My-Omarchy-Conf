# Hermes shared vs local split

Use this as the concrete checklist when the user wants the same Hermes behavior on two personal machines.

## Share

These can be shared when the user wants the same Hermes identity/config on both PCs:

- `~/.hermes/config.yaml`
- `~/.hermes/profiles/`
- `~/.hermes/skills/`
- `~/.hermes/.env`
- `~/.hermes/auth.json`
- shared MCP/tool configuration
- helper launchers and bootstrap docs

## Keep local

These should stay per-machine even for a single user:

- `~/.hermes/state.db`
- `~/.hermes/sessions/`
- `~/.hermes/logs/`
- caches and other temp/runtime files

## Why

The reason to keep runtime local is primarily sync safety:

- SQLite/state conflicts
- constantly-changing transcripts/logs
- noisy diffs and accidental corruption

The reason to share config is convenience and consistency:

- same default profile
- same skills
- same auth/providers
- same startup behavior when running `hermes`

## Recommended source of truth

For this user:

- private dotfiles repo = shared configuration layer
- local `~/.hermes` runtime files = per-machine state

If needed, secrets can live in the private dotfiles repo because the user explicitly accepted that tradeoff.

## Implementation checklist

1. Put the shared Hermes config layer in the dotfiles `ai-agent` package.
2. Link/stow shared files into `~/.hermes`.
3. Do not link runtime DB/session/log paths.
4. Set the preferred profile as the sticky default on each machine.
5. Test by launching plain `hermes` on both PCs and verifying the same startup behavior.
