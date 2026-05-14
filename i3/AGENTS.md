# Repository Guidelines

## Project Structure & Module Organization
This repository is the `i3` stow package for an Arch Linux X11 setup. The source of truth is `./.config/i3/` plus supporting helpers in `./.local/bin/` and `./default/` for Codex skills. Key runtime files include `./.config/i3/config`, `./.config/i3/scripts/`, `./.config/i3blocks/`, and `./.config/rofi/`.

## Build, Test, and Development Commands
Use GNU Stow to apply changes:

```bash
cd ~/Work/dotfiles && stow --restow i3
```

Validate the i3 config before reloading:

```bash
i3 -C -c ~/.config/i3/config
i3-msg reload
```

For shell helpers, run:

```bash
bash -n .local/bin/<script>
```

## Coding Style & Naming Conventions
Use POSIX shell or Bash for helper scripts, keep files ASCII, and prefer small, single-purpose scripts. Match existing naming patterns: lowercase with hyphens for user-facing wrappers (`i3-imgpicker`, `i3-sys`) and grouped helpers under `./.config/i3/scripts/<category>/`. Keep executable bits set on runnable scripts.

## Testing Guidelines
There is no automated test suite. Check changes by validating the i3 config, syntax-checking modified scripts, and confirming behavior in a live X11 session. For UI changes, verify the exact binding or popup path you touched rather than relying on stale docs.

## Commit & Pull Request Guidelines
Commit history is short and imperative, e.g. `Refactor i3 scripts and add skills` or `Add maximize keybind`. Keep commits focused on one behavior change. For pull requests, summarize the user-visible effect, list affected bindings/scripts, and include screenshots only for visual changes.

## Agent-Specific Instructions
Prefer editing the repo copy first, then restow. When keybindings change, update `README.md` and any manual help UI such as `i3-keys`. Avoid changing unrelated desktop subsystems unless the bug is in their runtime path.
