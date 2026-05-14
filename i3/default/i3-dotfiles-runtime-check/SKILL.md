---
name: i3-dotfiles-runtime-check
description: Use for `/home/sohaib/Work/dotfiles/i3` debugging or customization when the user reports a binding, launcher, wallpaper, clipboard, notification, or bar feature is not working. Focus on the real runtime path, autostart state, and the exact helper script the binding executes.
---

# i3 Dotfiles Runtime Check

Use this skill when the task is in the i3 dotfiles tree and the symptom depends on the live session rather than static config.

## Read first

- `~/.config/i3/config`
- the real runtime target of any bound command, via `readlink -f ~/.local/bin/<name>`
- the relevant helper script under `~/Work/dotfiles/i3/.config/i3/scripts/`
- session state for the subsystem involved, such as `dunst`, `copyq`, `walker`, or `batmon`

## Procedure

1. Trace the binding or launcher path before editing.
2. Check the live daemon or autostart state before changing script logic.
3. Prefer the active runtime path over stale checkout-local copies.
4. For wallpaper and theme issues, confirm everything routes through `scripts/wallpaper/wallpaper-set.sh`.
5. For clipboard and launcher issues, confirm the `i3` binding, the wrapper script, and the helper app all agree on the same frontend.
6. When keybindings change, update any manual help UI that mirrors them, especially `i3-keys` and `README.md`.

## Common checks

- Notifications: `dunstctl is-paused`
- Clipboard/history: `i3-cliphist`, `i3-imgclipwatch`, `walker`, `copyq`
- Wallpaper/theme: `wallpaper-set.sh`, `wallpaper-pick.sh`, `wallpaper-next.sh`
- Popups and window helpers: `float-toggle.sh`, `focus-next.sh`, `maximize.sh`

## Editing rule

Make the smallest change that matches the validated runtime path, then verify with the relevant syntax or state check.
