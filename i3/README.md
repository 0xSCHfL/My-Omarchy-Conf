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
- **fzf/st** wallpaper picker with previews
- Gaps, smart borders, floating window management

## Structure

```
~/.config/i3/
├── config                     # Main i3 configuration
├── scripts/
│   ├── launchers/
│   │   ├── i3-launch-walker   # Walker launcher for clipboard and menus
│   │   └── show-keybindings.sh # Display keybinding cheatsheet
│   ├── wallpaper/
│   │   ├── wallpaper-set.sh   # Restore wallpaper and pywal state
│   │   ├── wallpaper-pick.sh  # Wallpaper picker
│   │   ├── wallpaper-pick-fzf.sh
│   │   └── wallpaper-next.sh  # Cycle to next wallpaper
│   ├── notifications/
│   │   └── notifications.sh   # Dunst controls and history
│   ├── media/
│   │   └── volume-osd.sh      # Volume OSD
│   └── utils/
│       ├── float-toggle.sh    # Toggle floating/tiling
│       ├── focus-next.sh      # Cycle focus between windows
│       └── maximize.sh        # Full-width maximize toggle
├── .local/bin/
│   ├── i3-keys                # Manual keybinding menu
│   └── i3-sys                 # System menu
```

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+Space` | Application launcher (rofi) |
| `Super+q` | Browser (qutebrowser) |
| `Super+w` | Close window |
| `Super+h/j/k/l` | Focus left/down/up/right |
| `Super+Shift+h/j/k/l` | Move window left/down/up/right |
| `Super+Ctrl+h` | Split horizontal |
| `Super+Ctrl+l` | Split vertical |
| `Super+f` | Fullscreen toggle |
| `Super+Alt+f` | Full-width maximize toggle |
| `Super+t` | Toggle floating |
| `Super+Escape` | System menu |
| `Super+1-0` | Switch workspace |
| `Super+Shift+q` | Kill window |
| `Super+Shift+Space` | Toggle floating |
| `Super+Shift+1-0` | Move window to workspace |
| `Super+Shift+r` | Restart i3 |
| `Super+Shift+e` | Exit i3 |
| `Super+Ctrl+Space` | Wallpaper picker (rofi) |
| `Super+Shift+i` | Image picker |
| `Super+Shift+s` | System menu (kill/reboot/shutdown) |
| `Super+Shift+v` | Image clipboard history (`Space` selects, `Ctrl+d` deletes selected) |
| `Super+v` | Clipboard history (Walker) |
| `Super+Ctrl+v` | CopyQ show |
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

## Skills

- `default/i3-skill` is the source skill for i3 workflow guidance
- `default/i3-dotfiles-runtime-check` is the source skill for runtime-path debugging
- `~/.codex/skills/i3` should symlink to `default/i3-skill`
- `~/.codex/skills/i3-dotfiles-runtime-check` should symlink to `default/i3-dotfiles-runtime-check`

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
