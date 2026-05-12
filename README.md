# dotfiles

Multi-WM dotfiles managed with GNU Stow — i3, Hyprland, and dwm configs for Arch Linux.

## Structure

```
dotfiles/
├── hyprland/     # Hyprland configs (bash, nvim, waybar, ghostty, tmux, etc.)
├── i3/           # i3 configs (i3, polybar, kitty, rofi, i3status, etc.)
├── dwm/          # dwm + suckless tools (dwm, dmenu, st) + scripts
├── wallpapers/   # Shared wallpapers (not stowed)
├── install.sh    # One-command setup script
└── README.md
```

## Quick Install

```bash
git clone <repo-url> ~/some/path
cd ~/some/path
./install.sh
```

This stows all packages to `$HOME`. On your second PC, just clone and run the same script.

## Manual Stow

```bash
stow -t $HOME hyprland
stow -t $HOME --ignore=wallpapers i3
stow -t $HOME --ignore=wallpapers dwm
```

## Wallpapers

Stored in `wallpapers/` at the repo root. Scripts auto-detect the path relative to their location, so the repo can live anywhere.
