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
├── limine/          # Limine bootloader + Plymouth theme (not stowed)
│   ├── limine.conf          # Visuals only (Tokyo Night palette, backdrop)
│   ├── generate-default-limine # Auto-detect root layout and generate cmdline
│   ├── default-limine       # Legacy/reference cmdline for this laptop
│   ├── omarchy_hooks.conf   # mkinitcpio HOOKS with plymouth before encrypt
│   ├── backdrop.png         # Boot backdrop image
│   └── plymouth/            # Custom 0xSSfN Plymouth boot splash theme
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
| `battery` | 󰁺→󰁹 capacity % | cyan / yellow / red / green | left: CPU profile menu, middle: monitor, right: stats |
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
| `i3-gdrive` | Google Drive TUI (browse, download, upload, account switching, per-account mounts under `~/GoogleDrive/`) |
| `i3-cpufreq` | Rofi menu for auto-cpufreq stats, monitor, powersave, performance, reset |
| `i3-manuals` | Local Learn menu for repo-specific manuals |
| `notes` | Rofi notes launcher — browse/search Obsidian vaults, open in nvim |
| `i3-limine` | Refresh Limine config from dotfiles (like omarchy-refresh-limine) |
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
| `Super+Ctrl+X` | Dictation toggle (voxtype auto-types at cursor) |
| `Super+Ctrl+E` | Emoji picker |
| `Super+Ctrl+V` | Clipboard manager (copyq) |
| `Super+V` | Clipboard history (cliphist) |
| `Super+Shift+V` | Image clipboard history |
| `Super+Ctrl+W` | Wifi TUI (impala) |
| `Super+Ctrl+A` | Audio TUI (wiremix) |
| `Super+N` | Notes launcher (rofi vault picker → nvim) |
| `Super+Print` | Screenshot → clipboard |
| `Super+Ctrl+Print` | OCR screenshot → clipboard |
| `Super+Ctrl+K` | Show all keybindings |
| `Super+Alt+K` | Show all keybindings |
| `Super+Ctrl+B` | Battery CPU profile menu (auto-cpufreq) |
| `Super+Alt+M` | Local manuals / Learn menu |
| `Super+Alt+Space` | Local manuals / Learn menu |
| `Super+Ctrl+,` | Toggle notifications (dunst) |

### Boot / Login Flow

```
Limine (3s menu, Tokyo Night backdrop)
  └─ Plymouth (graphical LUKS passphrase prompt — 0xSSfN theme)
       └─ SDDM (i3-login theme, pywal colors — no autologin)
            └─ i3 session
```

### Limine Bootloader

Tokyo Night themed bootloader. Visual config lives on the FAT32 `/boot` partition, while the kernel command line is generated per machine.

**Root layout requirement:** do not copy a generated `/etc/default/limine` between machines. Root arguments are machine-specific. The helper below detects the currently booted root filesystem and writes the correct profile:

```bash
limine/generate-default-limine
```

Supported profiles:

```text
encrypted-btrfs: LUKS root -> /dev/mapper/<name>, Btrfs root, optional subvol
encrypted:       LUKS root -> /dev/mapper/<name>, non-Btrfs root
normal:          unencrypted root by UUID/PARTUUID, ext4/Btrfs/etc.
```

This exists because reusing the encrypted laptop config on a normal GPT/ext4 install makes the kernel search for a root device that does not exist:

```text
ERROR: Failed to mount '/dev/mapper/root' on real root
```

Run Limine setup from the target installed system, not from a live USB environment unless you are properly chrooted into the installed root. The detection is based on the current `/` mount.

| File | Purpose |
|------|---------|
| `limine/limine.conf` | **Visuals only** — palette, backdrop, margins, timeout |
| `limine/generate-default-limine` | **Kernel cmdline generator** — auto-detects encrypted vs normal root |
| `limine/default-limine` | Legacy/reference generated config for this laptop; do not copy blindly |
| `limine/omarchy_hooks.conf` | mkinitcpio HOOKS with `plymouth` before `keyboard`/`encrypt` |

Apply on a fresh install:

```bash
./install.sh limine          # skips if /boot/limine.conf exists
./install.sh limine --force  # overwrite and regenerate /etc/default/limine
```

`install.sh limine` also deploys the Plymouth theme and runs `limine-mkinitcpio` to bake the hooks into the UKI. If a machine already has a bad `/etc/default/limine` from another host, use `./install.sh limine --force` so the root cmdline is regenerated from that machine's real `/` mount.

To refresh from dotfiles on the running system (updates config + verifies boot health):

```bash
i3-limine
```

`i3-limine` verifies that `quiet splash` is present, `plymouth.enable=0` is absent, the Plymouth hook is in the live initramfs config, and the correct theme is set — exits non-zero if anything is wrong.

### Plymouth Boot Splash

Custom `0xSSfN` Plymouth theme (pixel-art logo, Tokyo Night progress bar, graphical disk unlock).

Theme files live in `limine/plymouth/` and are deployed to `/usr/share/plymouth/themes/0xSSfN/` by `install.sh limine` and `i3-limine`.

**Requirements:** `plymouth` hook must appear before `keyboard` and `encrypt` in mkinitcpio HOOKS (handled by `omarchy_hooks.conf`), and the kernel cmdline must contain `quiet splash` without `plymouth.enable=0`.

### SDDM Login Screen

Custom `i3-login` theme — symlinked from dotfiles, not stowed:

```
/usr/share/sddm/themes/i3-login → ~/Work/dotfiles/i3/sddm-theme/i3-login/
```

**No autologin** — the login screen is shown for security. SDDM runs in X11 mode (the Wayland override `10-wayland.conf` is removed since i3 is X11).

Colors auto-update via pywal when the wallpaper changes (`wallpaper-set.sh`).

Apply on fresh install:

```bash
./install.sh login    # or ./install.sh stow (runs login setup automatically)
```

This writes `/etc/sddm.conf.d/autologin.conf` (Theme + X11 only, no `[Autologin]` block), removes `10-wayland.conf`, and strips `pam_gnome_keyring` from `/etc/pam.d/sddm`.

### Dictation (voxtype)

- Daemon runs as a systemd user service (`systemctl --user status voxtype`)
- `Super+Ctrl+X` toggles recording — on stop, transcript auto-types at focused cursor
- Uses a robust toggle script with state/clipboard checks to avoid stale pastes
- Model: `base.en` (Whisper) stored in `~/.local/share/voxtype/models/`

### Pywal Color Flow

`wallpaper-set.sh` orchestrates everything on wallpaper change:
alacritty → dunst → SDDM theme → flameshot → Xresources

**Recent improvements:** Wallpaper picker now applies full pywal updates, and i3 reloads automatically so bar/workspace colors stay in sync.

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
