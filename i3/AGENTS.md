# Repository Guidelines

## Project Structure & Module Organization
This repository is the `i3` stow package for an Arch Linux X11 setup. The source of truth is the repo copy, not live symlink targets.

Important paths:
- `./.config/i3/config`: keybindings, startup commands, floating/window rules
- `./.config/i3/scripts/`: grouped helper scripts
- `./.config/i3/scripts/wallpaper/`: `wallpaper-set.sh`, picker, next wallpaper
- `./.config/i3/scripts/media/`: popup/TUI launchers such as wifi, audio, volume OSD
- `./.config/i3/scripts/launchers/`: launcher helpers
- `./.config/i3/scripts/notifications/`: notification helpers
- `./.config/i3/scripts/utils/`: focus, floating, maximize, fullscreen utilities
- `./.config/i3blocks/`: bar config and custom block scripts
- `./.config/polybar/`: secondary bar launcher
- `./.config/rofi/`: launcher themes
- `./.config/kitty/`, `./.config/alacritty/`, `./.config/dunst/`: themed app config
- `./.local/bin/`: user-facing custom scripts and wrappers
- `./shell/`: shell files stowed separately
- `./sddm-theme/i3-login/`: SDDM theme symlinked into `/usr/share/sddm/themes/`
- `./default/`: Codex skill/reference material for this i3 setup

## Build, Test, and Development Commands
Use GNU Stow to apply changes:

```bash
cd ~/Work/dotfiles && stow -t "$HOME" --restow \
  --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3
```

For shell files:

```bash
cd ~/Work/dotfiles && stow -d i3 -t "$HOME" --restow shell
```

Validate the i3 config before reloading:

```bash
i3 -C -c ~/.config/i3/config
i3-msg reload
```

For shell helpers, run:

```bash
bash -n .local/bin/<script>
bash -n .config/i3/scripts/<category>/<script>.sh
```

## Coding Style & Naming Conventions
Use POSIX shell or Bash for helper scripts, keep files ASCII, and prefer small, single-purpose scripts. Match existing naming patterns: lowercase with hyphens for user-facing wrappers (`i3-imgpicker`, `i3-sys`) and grouped helpers under `./.config/i3/scripts/<category>/`. Keep executable bits set on runnable scripts.

## Testing Guidelines
There is no automated test suite. Check changes by validating the i3 config, syntax-checking modified scripts, and confirming behavior in a live X11 session. For UI changes, verify the exact binding or popup path you touched rather than relying on stale docs.

For theme or wallpaper work, verify `wallpaper-set.sh` propagates colors/files to kitty, alacritty, dunst, rofi, SDDM, flameshot, and X resources. For SDDM work, remember `sddm-theme/i3-login/` is symlinked directly into `/usr/share/sddm/themes/i3-login/`, so repo edits are live.

## i3 Runtime Notes
- Before changing behavior, trace the exact live path: keybinding in `./.config/i3/config`, launcher/wrapper in `./.config/i3/scripts/` or `./.local/bin/`, and any `for_window` rule.
- If the user asks to inspect, diagnose, or asks why something differs between machines, do not edit first. Inspect and propose a concrete plan before making changes.
- When keybindings change, update `README.md` and the manual help UI `./.local/bin/i3-keys`; bindings do not sync automatically.
- `wallpaper-set.sh` is the central wallpaper/pywal hub. Keep wallpaper entry points routed through it.
- `Super+Shift+I` image picker wallpaper apply path must keep selected path quoting intact for filenames with spaces.
- `Super+Shift+g` opens the Google Drive TUI with `alacritty --class i3-gdrive -e i3-gdrive`; related logs are in `~/.cache/i3-gdrive.log`.
- `i3-gdrive` supports account switching with `a`. Diagnose with `tail -n 120 ~/.cache/i3-gdrive.log`.
- Google Drive window size is also controlled by the `for_window [class="i3-gdrive"]` rule in `./.config/i3/config`; do not change this without confirming the desired behavior first.
- For transient kitty-close debugging, monitor i3 window close events and inspect `/tmp/i3-kitty-close.log`.

## Commit & Pull Request Guidelines
Commit history is short and imperative, e.g. `Refactor i3 scripts and add skills` or `Add maximize keybind`. Keep commits focused on one behavior change. For pull requests, summarize the user-visible effect, list affected bindings/scripts, and include screenshots only for visual changes.

## Agent-Specific Instructions
Prefer editing the repo copy first, then restow. Do not edit live symlink targets directly. Avoid changing unrelated desktop subsystems unless the bug is in their runtime path. Keep fixes narrow, and preserve existing behavior unless the user explicitly asks to change it.
