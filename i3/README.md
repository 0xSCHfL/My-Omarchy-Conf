# i3 Config

My [i3](https://i3wm.org/) window manager configuration for Arch Linux.

## Features

- **Rofi** as application launcher (Super+Space)
- **Picom** compositor for transparency and smooth transitions
- **Kitty** as default terminal
- **Dunst** for notifications
- **CopyQ** for clipboard management
- **i3blocks** status bar with custom scripts
- **Pywal** integration for dynamic colorschemes
- **dwm-imgpicker** integration for wallpaper selection with previews
- Gaps, smart borders, floating window management

## Structure

```
~/.config/i3/
├── config                     # Main i3 configuration
├── scripts/
│   ├── wallpaper-set.sh       # Restore wallpaper on startup
│   ├── wallpaper-pick.sh      # Rofi-based wallpaper picker
│   ├── wallpaper-next.sh      # Cycle to next wallpaper
│   ├── float-toggle.sh        # Toggle floating/tiling
│   ├── focus-next.sh          # Cycle focus between windows
│   ├── notifications.sh       # Toggle do-not-disturb
│   └── show-keybindings.sh    # Display keybinding cheatsheet
```

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+Space` | Application launcher (rofi) |
| `Super+q` | Browser (qutebrowser) |
| `Super+w` | Close window |
| `Super+j/k` | Focus next/prev window |
| `Super+h/l` | Split horizontal / layout toggle |
| `Super+f` | Fullscreen toggle |
| `Super+Alt+f` | Full-width maximize toggle |
| `Super+t` | Toggle floating |
| `Super+1-0` | Switch workspace |
| `Super+Shift+q` | Kill window |
| `Super+Shift+Space` | Toggle floating |
| `Super+Shift+1-0` | Move window to workspace |
| `Super+Shift+r` | Restart i3 |
| `Super+Shift+e` | Exit i3 |
| `Super+Ctrl+Space` | Wallpaper picker (rofi) |
| `Super+Shift+i` | Image picker (fzfub + ueberzugpp) |
| `Super+Shift+s` | System menu (kill/reboot/shutdown) |
| `Super+Shift+v` | Image clipboard history |
| `Super+v` | Clipboard text history |
| `Super+n` | Notes |
| `Super+F1` | Keybinding cheatsheet |
| `Print` | Screenshot (flameshot) |
| `Alt+Print` | Screen recording |
| `Super+Ctrl+Print` | OCR screenshot |
| `Alt+Tab` | Cycle focus between windows |

See the [CLAUDE.md](./CLAUDE.md) for a full reference.

## Wallpaper

- Restored from `~/.cache/wal/wal` on startup (last pywal selection)
- Default: `../wallpapers/0024.jpg`
- Pick via Rofi with `Super+Ctrl+Space`
- Set with pywal via `Super+Shift+i` → select image → `Alt+w`

## Installation

The i3 config is managed with GNU Stow:

```bash
cd ~/Work/dotfiles && stow i3
```

## Session

Start via `.xinitrc`:

```bash
xsession i3    # symlinks .xinitrc → .xinitrc.i3
startx
```

Or select i3 from your display manager (SDDM).
