# Runtime Debugging

Use when a keybinding, launcher, wallpaper, clipboard, notification, bar feature, or daemon is broken in the live session.

## Read First

```bash
cat ~/.config/i3/config                          # Check keybinding exists
readlink -f ~/.local/bin/<script>                # Confirm symlink target
i3 -C -c ~/.config/i3/config                    # Validate i3 config syntax
journalctl --user -b | grep -i "dunst\|i3\|copyq"  # Check daemon errors
```

## Common Checks by Subsystem

| Subsystem | Check |
|-----------|-------|
| i3 config syntax | `i3 -C -c ~/.config/i3/config` |
| Notifications | `dunstctl is-paused` → `dunstctl set-paused false` |
| Clipboard text | Is `i3-cliphist` running? `pgrep -a cliphist` |
| Clipboard images | Is `i3-imgclipwatch` running? `pgrep -a i3-imgclipwatch` |
| Volume OSD | `yad` installed? `which yad` |
| Wallpaper/pywal | `cat ~/.cache/wal/wal` — does file exist? |
| SDDM colors | `cat /usr/share/sddm/themes/i3-login/theme.conf` |
| Lock screen | `which i3lock` — must be `i3lock-color` (AUR), not plain i3lock |
| Brave won't open | `ls ~/.config/BraveSoftware/Brave-Browser/Singleton*` → remove stale locks |
| Touchpad tap | `xinput list-props "SYNA308F:00 06CB:CD77 Touchpad" \| grep Tapping` |
| Bar not updating | `pgrep i3blocks` — restart: `pkill i3blocks && i3blocks &` |
| WiFi TUI | `which impala` — AUR package |
| Audio TUI | `which wiremix` — AUR package |

## Restart Daemons

```bash
pkill dunst && dunst &
pkill picom && picom --daemon
pkill i3blocks && i3blocks &
~/.config/polybar/launch.sh          # Restarts polybar + nm-applet + copyq + flameshot
wallpaper-set.sh                     # Re-applies wallpaper + pywal + SDDM colors
```

## i3 Controls

```bash
i3-msg reload        # Reload config (keybindings, rules) — no restart
i3-msg restart       # Full restart (re-runs exec_always)
i3-msg exit          # Exit i3
```

## Editing Rules

1. Edit dotfiles source in `~/Work/dotfiles/i3/`, not live symlink targets.
2. SDDM theme (`sddm-theme/i3-login/`) — edits are immediately live (symlinked directory).
3. After changing scripts, restow: `cd ~/Work/dotfiles && stow -t $HOME --restow --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3`
4. After changing keybindings: update `i3-keys` script and `references/keybindings.md`.
5. `window-title` i3blocks script: any `&`, `<`, `>` in output must be HTML-escaped — Pango parses it as markup and crashes i3bar if not escaped.

## Key Package Facts

- **i3lock-color** (AUR) is required — plain `i3lock` lacks `--bar-indicator`, `--clock`, `--time-str`
- **impala** (AUR) — wifi TUI launched in alacritty via `i3-launch-wifi.sh`
- **wiremix** (AUR) — audio TUI launched in alacritty via `i3-launch-audio.sh`
- **maim** — screenshots (not flameshot — flameshot is a tray app started via polybar/launch.sh)
- **Brave** keybinding pre-clears `~/.config/BraveSoftware/Brave-Browser/Singleton*` to handle crash locks
