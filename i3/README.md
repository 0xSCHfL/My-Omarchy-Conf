# i3 Config

My [i3](https://i3wm.org/) window manager configuration for Arch Linux.

## Features

- **Rofi** — app launcher, clipboard history, system menus
- **Picom** — compositor (transparency, shadows)
- **Kitty** — primary terminal; **Alacritty** for popup TUIs (wifi, audio)
- **Dunst** — notifications with pywal colors
- **cliphist** — text clipboard history daemon
- **i3blocks** — status bar with custom scripts
- **Polybar** — secondary bar launcher
- **Pywal** — dynamic colorschemes synced to kitty, alacritty, dunst, SDDM, rofi
- **SDDM i3-login theme** — custom login screen with pywal colors + wallpaper
- **i3lock-color** — lock screen with blurred background and bar indicator
- **fzfub + ueberzugpp** — image picker with previews
- **impala** — wifi TUI (AUR); **wiremix** — audio TUI (AUR)

## Structure

```
dotfiles/i3/
├── .config/i3/
│   ├── config                    # All keybindings, startup, window rules
│   └── scripts/
│       ├── wallpaper/            # wallpaper-set.sh, wallpaper-pick.sh, wallpaper-next.sh
│       ├── media/                # volume-osd.sh (yad), i3-launch-wifi.sh, i3-launch-audio.sh
│       ├── launchers/            # i3-email-picker.sh
│       ├── notifications/        # notifications.sh
│       └── utils/                # float-toggle.sh, focus-next.sh, maximize.sh
├── .config/i3blocks/             # Bar config + scripts (audio, wifi, battery, timer, etc.)
├── .config/polybar/              # Polybar config + launch.sh
├── .config/rofi/                 # Launcher themes (.rasi)
├── .config/kitty/                # kitty config (pywal include)
├── .config/alacritty/            # alacritty config (pywal include)
├── .config/dunst/                # Notification config + pywal generation
├── .config/tmux/                 # tmux config
├── .config/nvim/                 # Neovim config
├── .local/bin/                   # Custom scripts (see below)
├── shell/                        # .zshrc, .zshenv, .zsh_aliases (stowed separately)
├── .xinitrc.i3                   # X session startup
└── sddm-theme/i3-login/          # SDDM login theme (symlinked to /usr/share/sddm/themes/)
```

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+Space` | App launcher (rofi) |
| `Super+w` | Close window |
| `Super+q` | Browser (qutebrowser) |
| `Super+Shift+b` | Chromium |
| `Super+Shift+c` | Chromium |
| `Super+Shift+o` | Obsidian |
| `Super+Alt+t` | Telegram |
| `Super+Shift+n` | Neovim |
| `Super+Shift+f` | File manager (nautilus) |
| `Super+h/j/k/l` | Focus left/down/up/right |
| `Super+Shift+h/j/k/l` | Move window |
| `Super+Ctrl+h/l` | Split horizontal/vertical |
| `Super+f` | Fullscreen |
| `Super+Alt+f` | Full-width maximize |
| `Super+t` | Toggle floating |
| `Super+1-0` | Switch workspace |
| `Super+Shift+1-0` | Move window to workspace |
| `Super+Shift+r` | Restart i3 |
| `Super+Ctrl+r` | Reload i3 config |
| `Super+Shift+q` | Exit i3 |
| `Super+Escape` | System menu (suspend/reboot/shutdown) |
| `Super+Delete` | Process killer |
| `Super+x` | Lock screen |
| `Super+Ctrl+k` | Keybinding cheatsheet |
| `Super+Ctrl+b` | Battery CPU profile menu |
| `Super+Alt+c` | Run i3-check in a popup terminal |
| `Super+Alt+m` | Local manuals / Learn menu |
| `Super+Alt+Space` | Local manuals / Learn menu |
| `Super+Ctrl+Space` | i3 control menu |
| Search (inside control menu) | Search and launch apps, tools, capture, power, reminders, and Windows VM |
| `Super+Ctrl+Space` → Setup → Windows VM | Install, configure, launch, status, or stop a Docker Windows VM |
| `Super+Shift+i` | Image picker (fzfub) |
| `Super+Ctrl+v` | Text clipboard history (cliphist + rofi) |
| `Super+Shift+v` | Image clipboard history |
| `Super+v` | Alternate text clipboard history (cliphist + fzf) |
| `Super+n` | Notes |
| `Super+Ctrl+n` | Notification history |
| `Print` | Screenshot → clipboard (maim) |
| `Alt+Print` | Screen recording (ffmpeg) |
| `Super+Ctrl+Print` | OCR screenshot (tesseract) |
| `Super+Ctrl+c` | Capture menu: screenshot, OCR, recording, or image clipboard |
| `Super+o` | Toggle focused window as sticky picture-in-picture |
| `XF86AudioPlay/Next/Prev/Stop` | Spotify-only playback controls |
| `Super+Alt+p` | Choose a media player and toggle play-pause |
| `Super+Alt+n/b` | Spotify-only next/previous |
| `Alt+Tab` | Cycle focus |
| `Super+Ctrl+w` / `Super+Alt+w` | WiFi TUI (impala) |
| `Super+Ctrl+a` / `Super+Alt+a` | Audio TUI (wiremix) |
| `Super+Alt+v` | VPN TUI (vortix) |
| `Super+comma` | Close notification |
| `Super+Ctrl+comma` | Toggle pause notifications |

Web apps and app shortcuts (`Super+Shift+w/a/x/d/e`): WhatsApp, ChatGPT, X, Discord, Email

## Custom Scripts (`~/.local/bin/`)

| Script | Purpose |
|--------|---------|
| `i3-screenshot` | Area screenshot → clipboard (maim + xclip) |
| `i3-screenrecord` | Screen recording (ffmpeg) |
| `i3-ocr` | Area OCR → clipboard (maim + tesseract) |
| `i3-windows-vm` | Docker/KVM Windows VM manager with FreeRDP |
| `i3-lock` | Lock screen with blur (maim + magick + i3lock-color) |
| `i3-sys` | System menu: suspend/reboot/shutdown |
| `i3-check` | Validate i3 config, scripts, executable bits, dependencies, and docs drift |
| `i3-kill` | Fuzzy process killer (rofi) |
| `i3-keys` | Keybinding cheatsheet (rofi) |
| `i3-webapp` | Launch Chromium as webapp (`--app=<url>`) |
| `i3-manuals` | Local Learn menu for repo-specific manuals |
| `i3-imgpicker` | Image browser with ueberzugpp preview |
| `i3-imgcliphist` | Image clipboard history viewer |
| `i3-imgclipwatch` | Image clipboard watcher daemon |
| `i3-cliphist` | Text clipboard history daemon (cliphist) |
| `i3-cpufreq` | auto-cpufreq stats/monitor/profile menu |
| `batmon` | Battery low alert daemon |
| `fzfub` | fzf + ueberzugpp image browser |
| `notes` | Notes manager (rofi) |
| `xsession` | Switch between i3/DWM/Hyprland |

## Wallpaper & Pywal

`wallpaper-set.sh` is the central hub — it sets the wallpaper and propagates colors to:
kitty, alacritty, dunst, rofi, SDDM login theme, and X resources.

```bash
wallpaper-set.sh [/path/to/image]   # Set wallpaper + run pywal
wallpaper-set.sh --no-wal [path]    # Set wallpaper only, skip pywal
```

## Maintenance Checks

```bash
i3-check              # Validate config, scripts, permissions, dependencies, docs drift
i3-check --fix-perms  # chmod +x shebang scripts that are missing executable bits
i3-check --dedup      # Also run i3-dedup to heal duplicate/missing daemons
i3-dedup              # Runtime daemon cleanup/restart only
```

## SDDM Login Theme

Custom `i3-login` theme at `sddm-theme/i3-login/` — **symlinked** directly into
`/usr/share/sddm/themes/i3-login/` so edits are immediately live.

- Colors update automatically with each wallpaper change via `wallpaper-set.sh`
- Wallpaper syncs to `bg.jpg` on each change
- Built with `QtQuick 2.0` + `SddmComponents 2.0` only

## Installation

```bash
# Install packages + stow everything
./install.sh all

# Stow only
./install.sh stow
```

The install script handles:
- Stowing i3 main package and shell sub-package
- Symlinking the SDDM theme
- Writing `/etc/sddm.conf.d/autologin.conf`

Manual stow:
```bash
# i3 main package
cd ~/Work/dotfiles && stow -t $HOME --restow \
  --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3

# Shell sub-package
cd ~/Work/dotfiles && stow -d i3 -t $HOME --restow shell
```

## Tmux

Config at `.config/tmux/tmux.conf` (XDG path, auto-discovered).

Fresh machine setup:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux  # then: prefix + I  (Ctrl+Space + I) to install plugins
```

## Session

```bash
xsession i3    # symlinks ~/.xinitrc → .xinitrc.i3
startx         # launch i3
```

Or select i3 from SDDM login screen.

## Reference

See [CLAUDE.md](./CLAUDE.md) for full technical reference including startup sequence,
pywal color flow, stow rules, and applying changes.
