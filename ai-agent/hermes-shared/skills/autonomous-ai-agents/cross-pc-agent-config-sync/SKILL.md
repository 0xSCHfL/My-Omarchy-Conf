---
name: cross-pc-agent-config-sync
description: Share AI agent configuration cleanly across multiple personal machines while keeping runtime/session state local.
version: 1.0.0
author: Hermes Agent
license: MIT
---

# Cross-PC agent config sync

Use this skill when the user wants the same AI-agent setup on two or more personal machines, especially via a private dotfiles repo and optionally Dropbox or another secret-sync path.

## Goal

Make the agent behave the same on each machine when launched normally, without creating sync conflicts from runtime files.

## Core rule

Split the agent home into two layers:

1. Shared configuration layer
- skills/
- profiles/
- config.yaml
- auth.json
- .env
- MCP/tool configuration
- helper scripts/wrappers
- setup README/bootstrap docs

2. Local runtime layer
- session DBs
- sessions/transcripts
- logs
- caches
- temp/runtime state

Short version: sync config, not runtime.

## When a private repo is acceptable

If the user confirms the dotfiles repo is private and only theirs, it is acceptable to store auth.json and .env there if they explicitly want that. The main reason to keep runtime local is conflict/noise risk, not security.

## Recommended methodology

1. Pick one source of truth for shared config.
   - Usually a private dotfiles repo.
2. Mirror only stable agent files into that repo.
3. Link or stow those shared files into the live agent home on each machine.
4. Keep machine-specific runtime directories local and unshared.
5. Ensure the default profile is the same on both machines so plain startup behaves consistently.

## Hermes-specific mapping

Safe to share for a single user across personal machines:
- ~/.hermes/config.yaml
- ~/.hermes/profiles/
- ~/.hermes/.env
- ~/.hermes/auth.json
- shared custom skills, either by sharing ~/.hermes/skills/ directly or by keeping them in a repo path and exposing that path through skills.external_dirs

Keep local per machine:
- ~/.hermes/state.db
- ~/.hermes/sessions/
- ~/.hermes/logs/
- ~/.hermes/runtime/
- caches and temporary runtime files

Preferred pattern when Hermes lives alongside other agent configs in dotfiles:
- keep the live ~/.hermes home minimal and symlink only the shared config/profile/auth files
- store shared custom skills in a repo-owned directory such as ai-agent/hermes-shared/skills
- point Hermes at that directory with skills.external_dirs so custom skills sync cleanly without forcing the whole ~/.hermes tree to be shared

## Good implementation patterns

- Put shared config under a dedicated dotfiles package such as ai-agent/.
- When using GNU Stow or a similar dotfiles manager, isolate Hermes into its own sub-package (for example `ai-agent/hermes/.hermes`) so stowing Hermes does not collide with neighboring agent files.
- Use a short README that documents exactly what syncs and what stays local.
- Back up any pre-existing live ~/.hermes files before replacing them with symlinks.
- If the user wants “run hermes normally and it already works”, make the preferred Hermes profile the sticky default on each PC.
- Verify the sticky default explicitly after setup: `hermes profile list` should mark the intended profile as active, and `cat ~/.hermes/active_profile` should show that profile name.
- Fresh `hermes` launches use that sticky active profile. A `/new` inside an already-running session only resets the conversation; it does not switch profiles.
- After syncing a lean profile, verify MCP state separately from built-in toolsets. `hermes tools list` only shows the built-in toolsets for the platform; enabled MCP servers are a separate layer and can still trigger startup auth prompts or failures.
- To confirm an MCP-backed integration really works on the synced profile, use `hermes -p <profile> mcp list` for configured status and `hermes -p <profile> mcp test <server>` for an actual connectivity/auth check.
- Reuse the same pattern across Claude, Codex, OpenCode, and Hermes so the mental model stays consistent.
- Prefer sharing custom Hermes skills through a repo-owned path exposed by `skills.external_dirs` instead of syncing `~/.hermes/skills/` directly when the live skills tree may contain runtime-written metadata or mixed provenance.
- If the user is syncing via a private branch rather than main, preserve unrelated workstation noise by selectively staging only the shared-config files before committing and pushing.
- When one machine has newer repo changes, pull or merge those before pushing the new shared-agent changes so the second machine can fast-forward cleanly.

See also `references/git-sync-workflow.md` for a safe update/push sequence when local dotfiles edits and remote branch updates both exist.

## Pitfalls

- Do not sync live session/runtime databases across machines.
- Do not sync constantly-appended transcript/log folders.
- Do not mix shared configuration changes with unrelated repo noise; prepare narrow diffs.
- Do not assume secrets must stay out of a repo if the user explicitly says the repo is private; instead, confirm their comfort level and focus on conflict-prone files.
- Do not stow a broad parent package if it also contains unrelated agent files that already exist live; split Hermes into a narrower sub-package first to avoid symlink conflicts.
- If you need to bring in upstream or another branch before pushing, expect stash-pop conflicts in high-churn files like `install.sh`; resolve only the target feature additions and avoid accidentally committing unrelated workstation customizations.

## User-specific workflow preference

For this user, prefer a setup where both PCs launch the same default working environment with minimal manual steps, and keep the structure aligned with their existing Claude/Codex/OpenCode dotfiles layout.

## Support files

- See `references/hermes-shared-vs-local.md` for a concrete Hermes file split and implementation checklist.
- See `references/hermes-dotfiles-layout.md` for the repo layout, Stow pattern, and `skills.external_dirs` approach that worked well for this user.
