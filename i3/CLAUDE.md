# CLAUDE.md — i3 dotfiles

Guidance for Claude Code when working in this repository (i3 package and boot/login setup).

## Boot / Login Flow

```
Limine (3s menu, Tokyo Night backdrop)
  └─ Plymouth (graphical LUKS unlock — 0xSSfN theme, pixel-art logo)
       └─ SDDM (i3-login theme, pywal colors, no autologin)
            └─ i3 session
```

## Key Concepts

**GNU Stow tree-folding:** When a directory already exists in `$HOME` with unrelated files, stow creates file-level symlinks inside that directory rather than symlinking the whole thing. Use `readlink -f` to verify a file resolves into `~/Work/dotfiles/`, not just `-L` on the parent dir.

**Limine entry ordering:** `default_entry` is 1-indexed based on `/+NAME` entry order in `/boot/limine.conf`. `limine-snapper-sync` prepends snapshot entries, so entry #1 changes as snapshots are added/removed. The live `/boot/limine.conf` is the authoritative ordering; the repo file holds visuals only.

**UKI rebuild required:** After changing `omarchy_hooks.conf` (mkinitcpio HOOKS), the Unified Kernel Image must be rebuilt with `sudo limine-mkinitcpio` before the new hooks take effect at boot. The old UKI remains active until rebuilt.

**SDDM + X11:** Omarchy installs a `/etc/sddm.conf.d/10-wayland.conf` that sets `DisplayServer=wayland`. This breaks i3 (X11) — remove it. SDDM must run in X11 mode for i3.

## File Map

### Boot config (`limine/` — not stowed, lives on FAT32 `/boot`)

| Repo path | Deployed to | Purpose |
|-----------|-------------|---------|
| `limine/limine.conf` | `/boot/limine.conf` | Visuals only (palette, backdrop, margins) |
| `limine/default-limine` | `/etc/default/limine` | Kernel cmdline (`quiet splash`, LUKS, UKI path) |
| `limine/omarchy_hooks.conf` | `/etc/mkinitcpio.conf.d/omarchy_hooks.conf` | mkinitcpio HOOKS with `plymouth` before `keyboard`/`encrypt` |
| `limine/backdrop.png` | `/boot/backdrop.png` | Boot backdrop image |
| `limine/plymouth/` | `/usr/share/plymouth/themes/0xSSfN/` | Custom Plymouth theme |

### SDDM (`i3/sddm-theme/` — symlinked, not stowed)

| Repo path | Deployed to |
|-----------|-------------|
| `i3/sddm-theme/i3-login/` | `/usr/share/sddm/themes/i3-login` (symlink) |

### System config (written by `install.sh`, not tracked)

| Path | Purpose |
|------|---------|
| `/etc/sddm.conf.d/autologin.conf` | SDDM: theme + X11 keyboard, no autologin |
| `/etc/sddm.conf.d/10-wayland.conf` | Removed — conflicts with X11 i3 session |

## Applying Changes

| What changed | Command |
|-------------|---------|
| i3 config, scripts, colors | `i3-msg reload` |
| Wallpaper + all pywal colors | `wallpaper-set.sh <path>` |
| Dotfile added/moved in repo | `stow -d ~/Work/dotfiles -t $HOME --restow i3` |
| Limine visuals (`limine.conf`) | `i3-limine` (copies + verifies) |
| Kernel cmdline (`default-limine`) | `i3-limine` then reboot |
| Plymouth theme changed | `i3-limine` then reboot |
| mkinitcpio hooks changed | `i3-limine` → `sudo limine-mkinitcpio` then reboot |
| SDDM config | `./install.sh login` |
| Full fresh-PC setup | `./install.sh all` |

## `i3-limine` Script

Located at `i3/.local/bin/i3-limine`. Run without sudo — it calls sudo internally.

What it does:
1. Copies `limine.conf`, `default-limine`, `omarchy_hooks.conf`, `backdrop.png` to their system paths
2. Deploys `limine/plymouth/` → `/usr/share/plymouth/themes/0xSSfN/`
3. Runs `plymouth-set-default-theme 0xSSfN`
4. Runs `limine-update` + `limine-snapper-sync`
5. Verifies: `quiet splash` present, `plymouth.enable=0` absent, `plymouth` hook in live config, theme active

Exits non-zero with a clear error if any verification fails.

## Plymouth Theme (`0xSSfN`)

Custom theme in `limine/plymouth/`:
- `0xSSfN.plymouth` — theme descriptor
- `0xSSfN.script` — display logic (logo, progress bar, disk-unlock dialog)
- `logo.png` — pixel-art SVG logo converted at 800×188 via `rsvg-convert`
- `bullet.png`, `entry.png`, `lock.png`, `progress_bar.png`, `progress_box.png` — UI assets

Plymouth name (`0xSSfN`) matches the machine hostname.

## Pywal Color Flow

`wallpaper-set.sh` runs on wallpaper change and updates:
- alacritty (`~/.config/alacritty/alacritty-wal.toml`)
- dunst (via `~/.config/wal/hooks/dunst-colors`)
- SDDM theme background
- Xresources

## Packages Required for Boot/Login

```bash
# Plymouth
sudo pacman -S plymouth

# Limine tools (Omarchy installs these)
# limine-mkinitcpio, limine-update, limine-snapper-sync

# SDDM
sudo pacman -S sddm
sudo systemctl enable sddm
```

The Plymouth hook (`/etc/mkinitcpio.conf.d/omarchy_hooks.conf`) must be in place before running `limine-mkinitcpio`.
