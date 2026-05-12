# DWM Dotfiles

Personal DWM (Dynamic Window Manager) setup for Arch Linux.

## Structure

```
dwm/
├── .config/
│   ├── dunst/          # Notification daemon config (top-right, transparent)
│   ├── flameshot/      # Screenshot tool config
│   ├── picom/          # Compositor config (xrender, 8px corners, fading)
│   ├── qutebrowser/    # Web browser config
│   ├── rmpc/           # Music player (mpd) client config
│   └── wal/            # pywal color schemes & templates
├── .local/bin/         # Custom scripts (47 scripts)
├── dmenu/              # Patched dmenu (suckless, compiled)
├── dwm/                # Patched dwm (suckless, compiled, config.h)
├── scripts/            # Additional scripts (audio, wallpaper, statusbar)
│   ├── audio-video/    # Recording, audio switching
│   ├── images-photos-wallpapers/  # Wallpaper pickers, image tools
│   ├── shell/          # Utilities (dimmer, imv, xephyr, stats)
│   ├── shortcuts-menus/ # dmenu-based launchers (sys, notes, clipboard)
│   └── statusbar/      # Status bar component scripts
├── st/                 # Patched st (suckless terminal, compiled)
├── .xinitrc.dwm        # X11 startup entry point (use 'xsession dwm' to activate)
└── .gitignore
```

## Switching Between Window Managers

```bash
xsession dwm   # switch to DWM
xsession i3    # switch to i3
xsession       # show current session
```

Then run `startx` from a TTY.

## Autostart (.xinitrc.dwm)

The following run on `startx`:

| Component | Purpose |
|-----------|---------|
| `wallpaper-set.sh` | Sets wallpaper via feh |
| `picom` | Compositor (transparency, blur, shadows) |
| `dunst` | Notification daemon (top-right) |
| `dwm-statusbar` | Status bar (CPU, temp, mem, disk, net, vol, bat, time) |
| `nm-applet` | Network manager system tray |
| `polkit-gnome` | Authentication agent for privilege escalation |
| `xss-lock` + `i3lock` | Screen locker on suspend |
| `copyq` | Clipboard manager |
| `flameshot` | Screenshot tool |
| `dex` | XDG autostart entries |

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Space` | dmenu launcher |
| `Mod+Return` | Terminal (st) |
| `Mod+q` | Browser (qutebrowser) |
| `Mod+w` | Close window |
| `Mod+j/k` | Focus next/prev window |
| `Mod+h/l` | Resize master |
| `Mod+i/d` | Change master count |
| `Mod+Shift+Return` | Zoom (move to master) |
| `Mod+p` | Cycle layouts |
| `Mod+t` | Toggle float/center |
| `Mod+f` / `Mod+m` | Fullscreen / monocle |
| `Mod+b` | Toggle bar |
| `Print` | Screenshot (flameshot gui) |
| `Alt+Print` | Screen recording |
| `Mod+v` | Clipboard text history |
| `Mod+Shift+v` | Image clipboard history |
| `Mod+n` | Notes manager |
| `Mod+Shift+s` | System menu (kill/reboot/shutdown) |
| `Mod+Shift+t` | btop (floating terminal) |
| `Mod+Shift+w/g/x/d/e` | Web apps (WhatsApp, ChatGPT, X, Discord, Email) |
| `Mod+Shift+b` | Brave browser |
| `Mod+Shift+o` | Obsidian |
| `Mod+Shift+q` | Quit DWM |
| `Mod+Ctrl+Delete` | Quit DWM (close all) |
| `Mod+F1` | Show all keybindings |

## Image Picker (fzfub — Mod+Shift+i)

Open image browser with preview. Navigate with arrows/jk.

| Key | Action |
|-----|--------|
| `Alt+w` | Set as wallpaper (pywal) |
| `Enter` | Select file |
| `Ctrl+g` | Open in GIMP |
| `Ctrl+d` | Delete file |
| `Ctrl+e` | Strip EXIF |
| `Ctrl+b` | Convert to B&W |
| `Ctrl+w` | Add watermark |
| `Ctrl+t` | Remove background |
| `Ctrl+f/v` | Flip H/V |
| `Ctrl+l/h` | Black/white border |
| `Ctrl+s` | Scale 50% |
| `Alt+j/p` | Convert to JPG/PNG |

## System Menu (Mod+Shift+s)

| Option | Action |
|--------|--------|
| `kill` | Kill a process (fzf) |
| `suspend` | Suspend to RAM |
| `reboot` | Reboot |
| `shutdown` | Shutdown |

## Status Bar

The bar displays: `CPU% | Temp | RAM | Disk | Network | Volume | Battery | Time`

Uses `xsetroot -name` with a custom color scheme (Nord-inspired).

## Custom Scripts (~/.local/bin/)

| Script | Purpose |
|--------|---------|
| `dwm-statusbar` | Status bar loop |
| `dwm-screenshot` | Screenshot via flameshot |
| `dwm-screenrecord` | Screen recording |
| `dwm-ocr` | OCR from screenshot |
| `dwm-sys` | System menu (kill/suspend/reboot/shutdown) |
| `dwm-webapp` | Launch websites as web apps |
| `dwm-btop` | Floating btop via st |
| `dwm-imgpicker` | Image color picker |
| `dwm-imgcliphist` | Image clipboard history viewer |
| `dwm-cliphist` | Clipboard history viewer |
| `dwm-restart` | Restart DWM/X session |
| `notes` | dmenu notes manager |
| `txtcliphist` | Text clipboard history |
| `random_wallpaper` | Download/set random wallpaper |
| `wallpapermenu` | Wallpaper picker (nsxiv + pywal) |
| `fzfub-wallpapermenu` | Wallpaper picker (fzf + pywal) |
| `photomenu` | Photo editing options |
| `imgmgk` | ImageMagick presets |
| `imgcliphist` | Image clipboard history |
| `minimal-screenshot` | Lightweight screenshot |
| `dimmer` | Screen dimmer / night mode |
| `audioswitch` | Audio output switcher |
| `musicpicker` | Music player picker |
| `musicplaying` | Now-playing for status bar |
| `timer` | dmenu timer |
| `xephyr` | Xephyr for WM testing |

## Stack

| Tool | Purpose |
|------|---------|
| `dwm` | Window manager (suckless, patched) |
| `st` | Terminal (suckless, patched) |
| `dmenu` | App launcher (suckless, patched) |
| `picom` | Compositor (xrender, 8px corners) |
| `dunst` | Notification daemon |
| `feh` | Wallpaper setter |
| `flameshot` | Screenshots |
| `nm-applet` | Network tray |
| `copyq` | Clipboard manager |
| `xss-lock` + `i3lock` | Screen lock |
| `qutebrowser` | Web browser |
| `brave` | Secondary browser |
| `pywal` | Color scheme generation |
| `mpv` / `imv` | Media/image viewers |
| `btop` | System monitor |
| `pamixer` / `pactl` | Audio control |
| `nsxiv` | Image viewer / wallpaper picker |

## Install

```bash
# From dotfiles root
./install.sh all

# Build suckless tools
cd dwm/dwm && sudo make clean install
cd dwm/st && sudo make clean install
cd dwm/dmenu && sudo make clean install
```

## Starting DWM

```bash
# From TTY — first switch, then start
xsession dwm
startx
```
