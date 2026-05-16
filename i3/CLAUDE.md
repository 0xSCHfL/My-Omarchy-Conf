# CLAUDE.md — i3 Dotfiles

This file provides guidance to Claude Code when working with the i3 package of this dotfiles repo.

## System Context

- **OS:** Arch Linux
- **WM:** i3 (X11) — also has DWM and Hyprland; this package is i3-only
- **Display Manager:** SDDM — custom `i3-login` theme lives in `i3/sddm-theme/i3-login/`
- **Shell:** zsh (configs in `i3/shell/` sub-package)
- **AUR helper:** yay
- **Terminal:** kitty (primary), alacritty (popup windows for wifi/audio TUIs)
- **Hostname:** `0xSSfN`

## Dotfiles Structure (i3 package)

```
dotfiles/i3/
├── .config/
│   ├── i3/
│   │   ├── config                    # Main i3 config — all keybindings, startup, rules
│   │   └── scripts/
│   │       ├── wallpaper/            # wallpaper-set.sh, wallpaper-pick.sh, wallpaper-next.sh
│   │       ├── media/                # volume-osd.sh, i3-launch-wifi.sh, i3-launch-audio.sh
│   │       ├── launchers/            # i3-email-picker.sh
│   │       ├── notifications/        # notifications.sh
│   │       └── utils/                # float-toggle.sh, focus-next.sh, maximize.sh
│   ├── i3blocks/
│   │   ├── config                    # i3blocks bar config
│   │   └── scripts/                  # battery, audio, wifi, disks, systemstats, window-title, timer, spotify
│   ├── rofi/                         # Launcher themes (.rasi files)
│   ├── kitty/                        # kitty config (includes pywal colors-kitty.conf)
│   ├── alacritty/                    # alacritty config (includes alacritty-wal.toml)
│   ├── dunst/                        # Notification daemon config + pywal generation
│   ├── picom/                        # Compositor config
│   ├── tmux/                         # tmux config
│   ├── nvim/                         # Neovim config
│   ├── polybar/                      # Polybar config + launch.sh
│   └── wal/                          # pywal templates
├── .local/bin/                       # Custom scripts (see Scripts section below)
├── .xinitrc.i3                       # X session startup script
├── .xprofile                         # X profile
├── .gtkrc-2.0                        # GTK2 theme
├── shell/                            # Shell sub-package (stowed separately)
│   ├── .zshrc
│   ├── .zshenv
│   └── .zsh_aliases
└── sddm-theme/
    └── i3-login/                     # SDDM login theme (symlinked, not stowed)
        ├── Main.qml                  # QML login screen (QtQuick 2.0 + SddmComponents 2.0 only)
        ├── theme.conf                # Color config — overwritten by pywal on wallpaper change
        ├── metadata.desktop
        ├── logo.svg                  # Pixel-art logo in #c0b18b color
        └── bg.jpg                    # Wallpaper — synced by wallpaper-set.sh
```

## Stow Rules

The i3 package has sub-packages that must be stowed separately:

```bash
# Main i3 package (excludes shell/, sddm-theme/, default/)
cd ~/Work/dotfiles && stow -t $HOME --restow \
  --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3

# Shell sub-package
cd ~/Work/dotfiles && stow -d i3 -t $HOME --restow shell
```

The install script (`./install.sh stow`) handles both correctly.

## SDDM Theme

The login theme is a symlink, not stowed:
```
/usr/share/sddm/themes/i3-login → ~/Work/dotfiles/i3/sddm-theme/i3-login/
```

Edits to `sddm-theme/i3-login/Main.qml` are **immediately live** — no copy needed.

**QML constraint:** Only `QtQuick 2.0` and `SddmComponents 2.0` are available in SDDM.
No `QtQuick.Controls`, no `QtQuick.Layouts`. Use `Rectangle + TextInput`, `Column`, `Row`, `MouseArea`.

**Config:** `/etc/sddm.conf.d/autologin.conf`
```ini
[Autologin]
User=sohaib
Session=i3

[Theme]
Current=i3-login

[X11]
XkbLayout=fr
XkbModel=pc105
```

## Pywal Color Flow

`wallpaper-set.sh` orchestrates everything when wallpaper changes:

1. `feh --bg-scale` sets wallpaper
2. Copies wallpaper → `/usr/share/sddm/themes/i3-login/bg.jpg`
3. Runs `wal -q -n -i <wallpaper>`
4. Updates **alacritty** → `~/.config/alacritty/alacritty-wal.toml`
5. Updates **dunst** → runs `dunst/generate-from-pywal.sh`
6. Updates **SDDM theme** → writes colors to `/usr/share/sddm/themes/i3-login/theme.conf`
   - `background`, `foreground`, `accent` (color3), `error` (color1), `dimmed` (color8)
7. Updates **flameshot** draw color → `flameshot.ini`
8. Merges `colors.Xresources` via `xrdb`

SDDM `Main.qml` reads colors via `config.accent`, `config.foreground`, etc. with hardcoded fallbacks.

## i3 Startup Sequence (`.config/i3/config` exec lines)

| Order | Command | Purpose |
|-------|---------|---------|
| 1 | `dex --autostart` | XDG autostart apps |
| 2 | `systemctl --user start pipewire pipewire-pulse wireplumber` | Audio |
| 3 | `xinput set-prop "SYNA308F:00 06CB:CD77 Touchpad" "libinput Tapping Enabled" 1` | Tap-to-click |
| 4 | `xss-lock -- i3-lock` | Screen lock on suspend |
| 5 | `picom --daemon` | Compositor |
| 6 | `nm-applet` | Network manager tray |
| 7 | `dunst` | Notifications |
| 8 | `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1` | Polkit |
| 9 | `copyq` | Clipboard manager |
| 10 | `wallpaper-set.sh` | Wallpaper + pywal restore |
| 11 | `i3-cliphist` | Clipboard history daemon |
| 12 | `i3-imgclipwatch` | Image clipboard watcher |
| 13 | `batmon` | Battery alert daemon |
| 14 | `~/.config/i3blocks/scripts/battery-monitor` | Battery bar monitor |

## Custom Scripts (`~/.local/bin/`)

| Script | Purpose |
|--------|---------|
| `i3-screenshot` | Area screenshot → clipboard (maim + xclip) |
| `i3-screenrecord` | Screen recording (ffmpeg) |
| `i3-ocr` | Area screenshot → OCR text → clipboard (maim + tesseract) |
| `i3-lock` | Lock screen with blurred background (maim + magick + i3lock-color) |
| `i3-sys` | System menu: suspend/reboot/shutdown (rofi) |
| `i3-kill` | Process killer (rofi + fzf) |
| `i3-keys` | Show all keybindings (rofi) |
| `i3-webapp` | Launch Brave as a webapp: `WAYLAND_DISPLAY= GDK_BACKEND=x11 brave --app=<url>` |
| `i3-imgpicker` | Image browser with ueberzugpp preview (fzfub) |
| `i3-imgcliphist` | Image clipboard history viewer |
| `i3-imgclipwatch` | Watch clipboard for images, save to history |
| `i3-imgcliphist-copy` | Copy image from clipboard history |
| `i3-imgcliphist-refresh` | Refresh image clipboard history |
| `i3-cliphist` | Text clipboard history daemon (cliphist) |
| `i3-btop` | Floating btop in kitty |
| `batmon` | Battery monitor daemon (notify-send alerts) |
| `fzfub` | fzf + ueberzugpp image browser |
| `notes` | Notes manager (rofi) |
| `xsession` | Switch between i3/DWM/Hyprland (symlinks ~/.xinitrc) |

## i3blocks Bar Scripts (`.config/i3blocks/scripts/`)

| Script | Shows |
|--------|-------|
| `window-title` | Focused window title (Pango-escaped — & < > must be &amp; &lt; &gt;) |
| `audio` | Volume % — click opens wiremix in alacritty |
| `wifi` | SSID + signal — click opens impala in alacritty |
| `battery` | Battery % + charging status |
| `battery-monitor` | Low battery notification daemon |
| `disks` | Disk usage |
| `systemstats` | CPU% + temp + RAM (iostat + sensors) |
| `timer` | Countdown timer with menu |
| `spotify` | Now playing (playerctl) |
| `notifications` | Dunst paused/active indicator |
| `timedate` | Clock |

## Applying Changes

| Component | Command |
|-----------|---------|
| i3 config | `i3-msg reload` or `Super+Ctrl+r` |
| i3 restart | `i3-msg restart` or `Super+Shift+r` |
| i3 syntax check | `i3 -C -c ~/.config/i3/config` |
| Restow i3 | `cd ~/Work/dotfiles && stow -t $HOME --restow --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3` |
| Restow shell | `cd ~/Work/dotfiles && stow -d i3 -t $HOME --restow shell` |
| picom | `pkill picom && picom --daemon` |
| dunst | `pkill dunst && dunst &` |
| i3blocks | `pkill i3blocks && i3blocks &` |
| polybar | `~/.config/polybar/launch.sh` |
| Wallpaper + pywal | `wallpaper-set.sh [path]` |

## Key Package Facts

- **Screenshot:** `maim` (not flameshot — flameshot is started as tray app via polybar/launch.sh)
- **Lock screen:** `i3lock-color` (AUR) — plain `i3lock` lacks `--bar-indicator` and `--clock`
- **Clipboard history:** `cliphist` daemon + rofi for text; custom scripts for images
- **Wifi TUI:** `impala` (AUR) — launched in alacritty via `i3-launch-wifi.sh`
- **Audio TUI:** `wiremix` (AUR) — launched in alacritty via `i3-launch-audio.sh`
- **Brave:** keybinding clears `~/.config/BraveSoftware/Brave-Browser/Singleton*` before launching to avoid stale lock crashes
- **Touchpad:** tap-to-click set via `xinput` in `exec_always` (survives i3 reload)

## Veyon

```bash
veyon-master
```
Requires X11 — works in i3 and DWM, not Hyprland (Wayland).
