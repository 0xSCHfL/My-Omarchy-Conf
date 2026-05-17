# CLAUDE.md — Global

Global guidance for Claude Code across all projects.

## System Context

- **OS:** Arch Linux
- **Shell:** zsh
- **AUR helper:** yay
- **Terminal:** kitty (primary), alacritty (popup windows)
- **WM:** i3 (X11) — also has DWM and Hyprland

## Authorized CLIs

The following commands are pre-authorized — no need to ask before running them.

### i3 / WM
- `i3-msg` — reload, restart, get_tree, send IPC
- `i3 -C -c` — syntax check only
- `xdotool` — window focus/raise/search
- `xrandr` — display info/config
- `xinput` — input device properties
- `xrdb` — X resource database merge
- `xclip` / `xsel` — clipboard read/write

### Process Management
- `pgrep` / `pkill` / `kill` — detect and stop known daemons
- `ps` — process listing
- `setsid` — detach/launch background processes

### Notifications / Audio
- `notify-send` — send test/status notifications
- `dunstctl` — pause, resume, close notifications
- `pactl` — volume, sink, source queries and control
- `playerctl` — media playback control

### Network / Bluetooth
- `ip` — interface and address info
- `iwgetid` / `iwconfig` — wifi SSID and signal
- `busctl` / `dbus-send` — D-Bus inspection and queries
- `bluetoothctl` — bluetooth adapter and device control

### System Info
- `sensors` — CPU/hardware temps
- `iostat` — CPU and I/O stats
- `df` / `free` — disk and memory usage
- `journalctl` — read system/user logs

### Packages (read-only)
- `pacman -Q` / `-Ql` / `-Qi` / `-Ss` — query only, never install
- `yay -Ss` / `-Qi` — AUR query only

### Git
- `git status` / `diff` / `log` / `add` / `commit` / `push` — full git workflow

### Dotfiles
- `stow` — restow packages
- `chmod` — make scripts executable
- `find` / `grep` / `awk` / `sed` / `python3` — file search and text processing

## Always Ask First

- `sudo` — any privileged command
- `pacman -S` / `yay -S` — installing packages
- `rm` on files not created in the current session
- `git push --force`
