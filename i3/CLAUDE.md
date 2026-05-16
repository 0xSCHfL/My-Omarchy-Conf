# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

Multi-WM dotfiles for Arch Linux with Hyprland (Wayland), i3, and DWM (X11). SDDM handles session switching. Primary motivation for X11 WMs is Veyon Master compatibility.

## System Context

- **OS:** Arch Linux
- **Display Manager:** SDDM
- **AUR helper:** yay
- **Session entries:** `/usr/share/xsessions/i3.desktop` (+ dwm & hyprland)

## Dotfiles Structure

```
dotfiles/
├── ai-agent/     # Shared AI agent configs (OpenCode, Codex, Claude)
├── hyprland/     # Hyprland + Wayland config (bashrc managed here)
├── i3/           # i3 config (also includes shell/ sub-package)
├── dwm/          # DWM config + suckless tools + scripts
│   ├── dwm/      # Patched dwm source (config.h, compiled binary)
│   ├── st/       # Patched st terminal source
│   ├── dmenu/    # Patched dmenu source
│   ├── .local/bin/  # 47 custom scripts
│   └── scripts/  # Status bar, audio, wallpaper tools
└── wallpapers/
```

## Switching WMs (from TTY)

```bash
xsession dwm   # symlink ~/.xinitrc → .xinitrc.dwm
xsession i3    # symlink ~/.xinitrc → .xinitrc.i3
xsession       # show current session
startx         # launch the selected WM
```

## Stow Packages

| Package | Contents |
|---------|----------|
| `ai-agent` | OpenCode, Codex, and Claude configs + 33 shared skills |
| `hyprland` | `.bashrc`, Hyprland/Wayland configs |
| `i3` | i3 config, scripts, `shell/` sub-package (`.zshenv`, `.zshrc`, `.zsh_aliases`) |
| `dwm` | DWM config, suckless tools, `.local/bin/` scripts, `.xinitrc.dwm` |

Install via `./install.sh` (stows all + installs packages).

## DWM Config

**Source:** `dwm/dwm/config.h` — edit, then:

```bash
cd ~/Work/dotfiles/dwm/dwm && make && sudo make install
```

**Restart DWM in-place** (rebuilds + installs + reloads):
- Keybind: `Super+Shift+r`
- Script: `dwm-restart` (runs `make && sudo make install && pkill -HUP dwm`)

**Autostart** (`.xinitrc.dwm`): wallpaper, picom, dunst, dwm-statusbar, nm-applet, polkit, xss-lock+i3lock, copyq, flameshot, dex, autocutsel, xrandr monitor setup.

## DWM Keybindings

| Key | Action |
|-----|--------|
| `Super+Space` | dmenu launcher |
| `Super+Return` | Terminal (st) |
| `Super+q` | Browser (qutebrowser) |
| `Super+w` | Close window |
| `Super+j/k` | Focus next/prev window |
| `Super+h/l` | Resize master area |
| `Super+t` | Toggle floating |
| `Super+p` | Cycle layouts |
| `Super+b` | Toggle bar |
| `Super+f` / `Super+m` | Monocle layout |
| `Super+,/.` | Focus prev/next monitor |
| `Super+1-9` | Switch to tag |
| `Super+Shift+c` | Chromium |
| `Super+Shift+b` | Brave |
| `Super+Shift+r` | Rebuild + restart DWM |
| `Super+Shift+q` | Quit DWM |
| `Super+Shift+s` | System menu (kill/reboot/shutdown) |
| `Super+Shift+t` | btop (floating, centered on active window) |
| `Super+Shift+i` | Image picker (fzfub with ueberzugpp previews) |
| `Super+Shift+v` | Image clipboard history |
| `Super+Shift+w/g/x/d/e` | Web apps (WhatsApp, ChatGPT, X, Discord, Email) |
| `Super+Shift+o` | Obsidian |
| `Super+Shift+,/.` | Move window to prev/next monitor |
| `Super+Shift+1-9` | Move window to tag |
| `Super+v` | Clipboard text history |
| `Super+n` | Notes manager |
| `Super+F1` | Show all keybindings |
| `Super+Ctrl+Delete` | Quit DWM (close all) |
| `Print` | Screenshot (flameshot) |
| `Alt+Print` | Screen recording |
| `Super+Ctrl+Print` | OCR screenshot |

## Image Picker (Mod+Shift+i — fzfub)

| Key | Action |
|-----|--------|
| `Alt+w` | Set wallpaper (pywal) |
| `Enter` | Select / copy path |
| `Ctrl+g` | GIMP |
| `Ctrl+d` | Delete |
| `Ctrl+e` | Strip EXIF |
| `Ctrl+b` | B&W convert |
| `Ctrl+f/v` | Flip H/V |
| `Ctrl+l/h` | Black/white border |
| `Alt+j/p` | Convert JPG/PNG |
| `Ctrl+r` | Refresh |

Both `dwm-imgpicker` and `dwm-btop` center on the active window (not screen center).

## System Menu (Mod+Shift+s)

```
kill       → fzf process killer
suspend    → systemctl suspend
reboot     → systemctl reboot
shutdown   → shutdown now
```

## Status Bar

`dwm-statusbar` shows: CPU% | Temp | RAM | Disk | Network | Volume | Battery | Time

Uses `xsetroot -name` with Nord-inspired colors (SchemeSep, SchemeIcon, SchemeVal, SchemeWarn).

## Custom Scripts (~/.local/bin/)

| Script | Purpose |
|--------|---------|
| `dwm-statusbar` | Status bar loop |
| `dwm-screenshot` | Screenshot via flameshot |
| `dwm-screenrecord` | Screen recording |
| `dwm-ocr` | OCR from screenshot |
| `dwm-sys` | System menu |
| `dwm-webapp` | Web apps via Brave |
| `dwm-btop` | Floating btop |
| `dwm-imgpicker` | Image browser with previews |
| `dwm-imgcliphist` | Image clipboard history |
| `dwm-cliphist` | Clipboard text history |
| `dwm-restart` | Rebuild + restart DWM |
| `dwm-keys` | Show all keybindings |
| `xsession` | Switch between dwm/i3 |
| `fzfub` | fzf + ueberzugpp image browser |
| `notes` | dmenu notes manager |
| `random_wallpaper` | Random wallpaper downloader |
| `wallpapermenu` | Wallpaper picker (nsxiv + pywal) |

## Monitor Setup

`.xinitrc.dwm` runs:
```bash
xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1 --primary
```

Adjust output names as needed for your hardware.

## Clipboard

- `autocutsel -fork` in `.xinitrc.dwm` syncs PRIMARY ↔ CLIPBOARD
- Mouse selection in st → available for Ctrl+V everywhere

## Applying Changes

| Component | Command |
|-----------|---------|
| DWM config | `cd ~/Work/dotfiles/dwm/dwm && make && sudo make install && pkill -HUP dwm` |
| DWM restart | `Super+Shift+r` (builds + installs + restarts) |
| Scripts | `cd ~/Work/dotfiles && stow --restow dwm` |
| Shell aliases | `cd ~/Work/dotfiles && stow -d i3 -t $HOME shell` |
| picom | `pkill picom && picom --daemon` |
| dunst | `pkill dunst && dunst &` |
| xsession | `xsession dwm` or `xsession i3` |

## Veyon

```bash
veyon-master
```
Requires X11 — works in DWM and i3, not Hyprland (Wayland).
