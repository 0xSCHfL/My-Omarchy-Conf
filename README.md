# dotfiles

Multi-WM dotfiles managed with GNU Stow — i3, Hyprland, and DWM configs for Arch Linux.

## System

| | |
|---|---|
| **OS** | Arch Linux |
| **WMs** | i3 (primary) · DWM · Hyprland |
| **Display Manager** | SDDM with custom `i3-login` theme |
| **Shell** | zsh |
| **Terminal** | kitty (primary) · alacritty (popups) |
| **AUR helper** | yay |

---

## Structure

```
dotfiles/
├── i3/              # i3 window manager (primary setup)
├── dwm/             # DWM + suckless tools (dwm, dmenu, st, dwmblocks)
├── hyprland/        # Hyprland (Wayland) — nvim, waybar, ghostty, tmux
├── ai-agent/        # Shared AI agent configs (Claude Code, OpenCode, Codex)
├── shell/           # Shared zsh config
├── tmux/            # Shared tmux config
├── wallpapers/      # Shared wallpapers (not stowed)
├── install.sh       # One-command setup script
└── README.md
```

---

## Quick Install

```bash
git clone git@github.com:0xSCHfL/dotfiles.git ~/Work/dotfiles
cd ~/Work/dotfiles
./install.sh
```

### Manual Stow

```bash
# i3 package (excludes shell/ and sddm-theme/)
stow -t $HOME --restow --ignore='^shell$' --ignore='^sddm-theme$' --ignore='^default$' i3

# Shell sub-package
stow -d i3 -t $HOME --restow shell

# Other packages
stow -t $HOME dwm
stow -t $HOME hyprland
stow -t $HOME ai-agent
```

---

## i3 Package

### Bar (i3blocks)

Colorized blocks with nerd font icons — each block has its own color matching the pywal theme palette.

| Block | Shows | Color | Click |
|-------|-------|-------|-------|
| `window-title` | Focused window title | dynamic | — |
| `voxtype` | 🎤 REC / ⏳ when dictating | red / yellow | — |
| `spotify` | Now playing | green | — |
| `wifi` | 󰤨 SSID (󰤭 when down) | white / dimmed | opens impala TUI |
| `bluetooth` | 󰂱 device / 󰂯 on / 󰂲 off | blue | opens bluetui |
| `ethernet` | 󰈀 IP — hidden when unplugged | orange | — |
| `load` | 󰾆 load average | yellow | — |
| `systemstats` | 󰍛 CPU°C · 󰘚 RAM | green→yellow→red | opens htop |
| `disks` | disk usage / free space | green | opens disk info |
| `audio` | 󰕾/󰖀/󰕿/󰖁 volume % | pink | opens wiremix TUI |
| `timer` | countdown timer | lavender | — |
| `battery` | 󰁺→󰁹 capacity % | cyan / yellow / red / green | opens auto-cpufreq |
| `time` | date + time | blue | — |

> Restore pre-colorization bar: `cp ~/.config/i3blocks/config.bak ~/.config/i3blocks/config`

### Custom Scripts (`~/.local/bin/`)

| Script | Purpose |
|--------|---------|
| `i3-screenshot` | Area screenshot → clipboard (maim + xclip) |
| `i3-screenrecord` | Screen recording toggle (ffmpeg) |
| `i3-ocr` | Area screenshot → OCR text → clipboard |
| `i3-lock` | Lock screen with blurred background (i3lock-color) |
| `i3-sys` | System menu: suspend / reboot / shutdown (rofi) |
| `i3-kill` | Kill a process via rofi picker |
| `i3-keys` | Show all keybindings (rofi) |
| `i3-webapp` | Launch Brave as a webapp (`--app=<url>`) |
| `i3-emojipick` | Emoji picker (rofimoji) |
| `i3-imgpicker` | Image browser with ueberzugpp preview |
| `i3-imgcliphist` | Image clipboard history viewer |
| `i3-imgclipwatch` | Watch clipboard for images, save to history |
| `i3-cliphist` | Text clipboard history daemon (cliphist) |
| `i3-btop` | Floating btop in kitty |
| `i3-dedup` | Kill duplicate daemons and revive crashed ones |
| `i3-gdrive` | Google Drive TUI (browse, download, upload, account switching) |
| `batmon` | Battery alert daemon (notify at ≤20%, no spam) |
| `fzfub` | fzf + ueberzugpp image browser |
| `xsession` | Switch between i3 / DWM / Hyprland |

### Keybindings (highlights)

| Binding | Action |
|---------|--------|
| `Super+Enter` | Terminal (kitty) |
| `Super+D` | App launcher (rofi) |
| `Super+F` | True fullscreen (hides bar) |
| `Super+Alt+F` | Maximize (fills workspace, keeps gaps + bar) |
| `Alt+Tab` | Cycle windows (propagates maximize state) |
| `Super+Ctrl+X` | Dictation toggle (voxtype → clipboard → Ctrl+V) |
| `Super+Ctrl+E` | Emoji picker |
| `Super+Ctrl+V` | Clipboard manager (copyq) |
| `Super+V` | Clipboard history (cliphist) |
| `Super+Shift+V` | Image clipboard history |
| `Super+Ctrl+W` | Wifi TUI (impala) |
| `Super+Ctrl+A` | Audio TUI (wiremix) |
| `Super+Print` | Screenshot → clipboard |
| `Super+Ctrl+Print` | OCR screenshot → clipboard |
| `Super+Ctrl+K` | Show all keybindings |
| `Super+Ctrl+,` | Toggle notifications (dunst) |

### SDDM Theme

Custom `i3-login` theme — symlinked, not stowed:

```
/usr/share/sddm/themes/i3-login → ~/Work/dotfiles/i3/sddm-theme/i3-login/
```

Colors auto-update via pywal when wallpaper changes. Background syncs with `wallpaper-set.sh`.

### Dictation (voxtype)

- Daemon runs as a systemd user service (`systemctl --user status voxtype`)
- `Super+Ctrl+X` toggles recording — transcribed text lands in clipboard
- Paste with `Ctrl+V` (X11 clipboard mode, no ydotool needed)
- Model: `base.en` (Whisper) stored in `~/.local/share/voxtype/models/`

### Pywal Color Flow

`wallpaper-set.sh` orchestrates everything on wallpaper change:
alacritty → dunst → SDDM theme → flameshot → Xresources

**Recent improvements:** Stabilized bar (i3blocks) color updates on wallpaper change to prevent sync issues.

### Maintenance

```bash
i3-dedup          # Fix duplicates / revive crashed daemons after Super+Shift+R
i3-msg reload     # Reload i3 config  (Super+Ctrl+R)
i3-msg restart    # Restart i3        (Super+Shift+R)
wallpaper-set.sh  # Set wallpaper + regenerate all pywal colors
```

---

## AI Agent Package

Centralized configs for **Claude Code**, **OpenCode**, and **Codex CLI**.

- `~/.claude/settings.json` → symlinked from `ai-agent/.claude/settings.json`
- Global Claude Code instructions in `~/CLAUDE.md` (authorized CLIs, system context)
- Project-specific instructions in each project's own `CLAUDE.md`
- Per-project MCP overrides via `.claude/settings.json` in each project root

---

## Wallpapers

Stored in `wallpapers/` at the repo root. Set with:

```bash
wallpaper-set.sh ~/Work/dotfiles/wallpapers/your-wallpaper.jpg
```
