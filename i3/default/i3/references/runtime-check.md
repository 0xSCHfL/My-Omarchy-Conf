# Runtime Debugging

Use when a binding, launcher, wallpaper, clipboard, notification, or bar feature is not working in the live session.

## Read first

- `~/.config/i3/config`
- Real runtime target of any bound command: `readlink -f ~/.local/bin/<name>`
- Relevant helper script under `~/Work/dotfiles/i3/.config/i3/scripts/`
- Session state: `dunst`, `copyq`, `walker`, `batmon`

## Procedure

1. Trace the binding or launcher path before editing.
2. Check the live daemon or autostart state before changing script logic.
3. Prefer the active runtime path over stale checkout-local copies.
4. For wallpaper and theme issues, confirm everything routes through `scripts/wallpaper/wallpaper-set.sh`.
5. For clipboard and launcher issues, confirm the `i3` binding, the wrapper script, and the helper app all agree on the same frontend.
6. When keybindings change, update any manual help UI that mirrors them, especially `i3-keys` and `README.md`.

## Common checks

| Subsystem | Check |
|-----------|-------|
| Notifications | `dunstctl is-paused` |
| Clipboard/history | `i3-cliphist`, `i3-imgclipwatch`, `walker`, `copyq` |
| Wallpaper/theme | `wallpaper-set.sh`, `wallpaper-pick.sh`, `wallpaper-next.sh` |
| Popups/window helpers | `float-toggle.sh`, `focus-next.sh`, `maximize.sh` |

## Editing rule

Make the smallest change that matches the validated runtime path, then verify with the relevant syntax or state check.
