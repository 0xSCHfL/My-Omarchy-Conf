# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal i3 window manager rice for Arch Linux. The goal is to build a clean, customized i3 setup alongside an existing Hyprland installation, with SDDM as the display manager for switching between sessions. The primary motivation is X11 compatibility (specifically for Veyon Master, which doesn't work on Wayland/Hyprland).

## System Context

- **OS:** Arch Linux
- **Display Manager:** SDDM (manages both Hyprland and i3 sessions)
- **i3 session entry:** `/usr/share/xsessions/i3.desktop`
- **AUR helper:** yay
- **Existing WM:** Hyprland (kept, not removed)

## Installed Stack

| Tool | Purpose |
|------|---------|
| `i3-wm` | Window manager |
| `polybar` | Status bar (replacing i3bar) |
| `picom` | Compositor (transparency, blur, shadows) |
| `rofi` | App launcher (replacing dmenu) |
| `feh` | Wallpaper setter |
| `dunst` | Notification daemon |
| `i3lock` + `xss-lock` | Screen locking |
| `network-manager-applet` | System tray network indicator |

## Config File Locations

| Config | Path |
|--------|------|
| i3 | `~/.config/i3/config` |
| polybar | `~/.config/polybar/config.ini` |
| picom | `~/.config/picom/picom.conf` |
| rofi | `~/.config/rofi/config.rasi` |
| dunst | `~/.config/dunst/dunstrc` |

## Ricing Approach

- Polybar config is inspired by [skillarch](https://github.com/laluka/skillarch) — borrow and adapt, not copy wholesale
- All other components are configured manually from scratch
- Wallpaper set via `feh --bg-scale /path/to/wallpaper` in i3 config exec line

## Key i3 Config Patterns

Apply config changes and reload without logging out:
```
$mod+Shift+r   # reload i3 config
$mod+Shift+e   # exit i3
```

Restart i3 in-place (preserves layout):
```
$mod+Shift+r   → i3-msg restart
```

Launch rofi instead of dmenu — replace in `~/.config/i3/config`:
```
bindsym $mod+d exec rofi -show drun
```

Start polybar on i3 launch — add to i3 config:
```
exec_always --no-startup-id $HOME/.config/polybar/launch.sh
```

## Applying Changes

- **i3 config:** `i3-msg reload` or `$mod+Shift+r`
- **polybar:** kill and relaunch via `~/.config/polybar/launch.sh`
- **picom:** `pkill picom && picom --daemon`
- **dunst:** `pkill dunst && dunst &`

## Veyon

Veyon Master is the reason for switching to X11. Once in i3, test with:
```bash
veyon-master
```
It requires X11 for screen capture (xshm) and remote input (XTest) — both unavailable on Wayland.
