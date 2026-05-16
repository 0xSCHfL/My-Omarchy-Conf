# i3 Config

My [i3](https://i3wm.org/) window manager configuration for Arch Linux.

## Features

- **Rofi** as application launcher (Super+Space)
- **Picom** compositor for transparency and smooth transitions
- **Kitty** as default terminal
- **Dunst** for notifications
- **CopyQ** for clipboard management
- **Floating volume popup** for audio feedback
- **i3blocks** status bar with custom scripts
- **Pywal** integration for dynamic colorschemes
- **fzf/st** wallpaper picker with previews
- Gaps, smart borders, floating window management

## Structure

```
~
├── .config/i3/                # Main i3 configuration
├── .config/swayosd/           # Optional SwayOSD theme/config files
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
│   │   └── volume-osd.sh      # Floating volume popup wrapper
│   └── utils/
│       ├── float-toggle.sh    # Toggle floating/tiling
│       ├── focus-next.sh      # Cycle focus between windows
│       └── maximize.sh        # Full-width maximize toggle
├── .local/bin/
│   ├── i3-keys                # Manual keybinding menu
│   └── i3-sys                 # System menu
├── shell/
│   ├── .zshenv                # Exports (PATH, XDG, EDITOR, etc.)
│   ├── .zshrc                 # Zsh config, functions, keybinds
│   └── .zsh_aliases           # Aliases only (sourced by .zshrc)
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

- `default/i3` is the merged i3 skill (config + runtime debugging) symlinked to `~/.config/opencode/skill/i3`
  - `references/keybindings.md` — full keybinding reference
  - `references/wallpaper.md` — wallpaper & pywal docs
  - `references/runtime-check.md` — live session debugging guide

## Installation

The i3 config is managed with GNU Stow:

```bash
cd ~/Work/dotfiles && stow i3
```

The `shell/` sub-package is stowed separately:

```bash
cd ~/Work/dotfiles && stow -d i3 -t $HOME shell
```

This creates `~/.zshenv`, `~/.zshrc`, and `~/.zsh_aliases` as symlinks.

## Tmux

Config lives at `.config/tmux/tmux.conf` (XDG path — tmux auto-discovers it).

**On a fresh machine:**

```bash
# 1. Stow links ~/.config/tmux/tmux.conf automatically
cd ~/Work/dotfiles && stow i3

# 2. Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 3. Start tmux and install plugins
tmux
# then press: prefix + I  (Ctrl+Space + I)
```

Plugins are installed by TPM into `~/.tmux/plugins/` and are not tracked in dotfiles.

## Session

Start via `.xinitrc`:

```bash
xsession i3    # symlinks .xinitrc → .xinitrc.i3
startx
```

Or select i3 from your display manager (SDDM).
