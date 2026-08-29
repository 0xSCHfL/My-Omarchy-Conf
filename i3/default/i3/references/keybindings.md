# i3 Keybindings

Mod = Super (Windows key)

## Apps & Launchers

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (kitty) |
| `Mod+Space` | App launcher (rofi drun) |
| `Mod+q` | Browser (qutebrowser) |
| `Mod+Shift+b` | Brave (clears Singleton lock first) |
| `Mod+Shift+Alt+b` | Brave incognito |
| `Mod+Shift+c` | Chromium |
| `Mod+Shift+o` | Obsidian |
| `Mod+Alt+t` | Telegram |
| `Mod+Shift+n` | Neovim (kitty) |
| `Mod+n` | Notes manager |
| `Mod+Shift+f` | File manager (nautilus) |

## Web Apps and App Shortcuts

| Key | Action |
|-----|--------|
| `Mod+Shift+w` | WhatsApp web app |
| `Mod+Shift+a` | ChatGPT desktop app |
| `Mod+Shift+x` | X (Twitter) web app |
| `Mod+Shift+d` | Discord app |
| `Mod+Shift+e` | Email picker |

## Window Management

| Key | Action |
|-----|--------|
| `Mod+w` | Close window |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window left/down/up/right |
| `Mod+Left/Down/Up/Right` | Focus (arrow keys) |
| `Mod+Shift+Left/Down/Up/Right` | Move (arrow keys) |
| `Mod+Ctrl+h` | Split horizontal |
| `Mod+Ctrl+l` | Split vertical |
| `Mod+f` | Fullscreen toggle |
| `Mod+Alt+f` | Full-width maximize (maximize.sh) |
| `Mod+t` | Float-toggle (float-toggle.sh) |
| `Mod+Shift+Space` | Floating toggle |
| `Mod+o` | Layout stacking |
| `Mod+e` | Layout toggle split |
| `Mod+a` | Focus parent |
| `Mod+s` | Move to scratchpad |
| `Mod+Alt+s` | Show scratchpad |
| `Alt+Tab` | Cycle focus next (focus-next.sh) |
| `Alt+Shift+Tab` | Cycle focus prev |

## Workspaces

| Key | Action |
|-----|--------|
| `Mod+1-0` | Switch to workspace |
| `Mod+Shift+1-0` | Move window to workspace (and follow) |
| `Mod+o` | Toggle focused window as sticky picture-in-picture |
| `Mod+PageDown` | Next workspace (also touchpad 3-finger swipe left) |
| `Mod+PageUp` | Previous workspace (also touchpad 3-finger swipe right) |

## System

| Key | Action |
|-----|--------|
| `Mod+Shift+r` | Restart i3 |
| `Mod+Ctrl+r` | Reload i3 config |
| `Mod+Shift+q` | Exit i3 (rofi confirm) |
| `Mod+Escape` | System menu: suspend/reboot/shutdown (i3-sys) |
| `Mod+Delete` | Process killer (i3-kill) |
| `Mod+x` | Lock screen (i3lock-color + maim blur) |
| `Mod+Ctrl+k` | Keybinding cheatsheet (i3-keys) |
| `Mod+Alt+k` | Keybinding cheatsheet (i3-keys) |
| `Mod+Alt+c` | Run i3-check in a popup terminal |
| `Mod+Alt+m` | Local manuals / Learn menu (i3-manuals) |
| `Mod+Alt+Space` | Local manuals / Learn menu (i3-manuals) |
| `Mod+Alt+v` | WireGuard/OpenVPN VPN TUI (vortix) |

## Media & Volume

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up (volume-osd.sh + yad OSD) |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute (pactl) |
| `XF86AudioPlay` | Spotify-only play-pause |
| `XF86AudioNext` | Spotify-only next track |
| `XF86AudioPrev` | Spotify-only previous track |
| `XF86AudioStop` | Spotify-only stop |
| `Mod+Alt+p` | Choose a media player and toggle play-pause |
| `Mod+Alt+n` | Spotify-only next track |
| `Mod+Alt+b` | Spotify-only previous track |
| `XF86MonBrightnessUp` | Brightness +5% (brightnessctl) |
| `XF86MonBrightnessDown` | Brightness -5% |
| `Mod+Ctrl+w` | WiFi TUI (impala in alacritty) |
| `Mod+Ctrl+a` | Audio mixer TUI (wiremix in alacritty) |
| `Mod+Ctrl+b` | Battery CPU profile menu (auto-cpufreq) |
| `Mod+Shift+t` | btop (kitty) |

## Notifications (dunst)

| Key | Action |
|-----|--------|
| `Mod+comma` | Close last notification |
| `Mod+Shift+comma` | Close all notifications |
| `Mod+Ctrl+comma` | Toggle pause notifications |
| `Mod+Alt+comma` | Invoke last notification action |
| `Mod+Ctrl+n` | Notification history (notifications.sh) |

## Screenshot & OCR

| Key | Action |
|-----|--------|
| `Print` | Area screenshot → clipboard (maim + xclip) |
| `Alt+Print` | Screen recording (i3-screenrecord + ffmpeg) |
| `Mod+Ctrl+Print` | Area OCR → clipboard (maim + tesseract) |
| `Mod+Ctrl+c` | Capture menu: screenshot, OCR, recording, or image clipboard |

## Clipboard & Images

| Key | Action |
|-----|--------|
| `Mod+v` | Combined text and image clipboard history |
| `Mod+Shift+i` | Image picker (fzfub + ueberzugpp) |

## Wallpaper

| Key | Action |
|-----|--------|
| `Mod+Ctrl+Space` | Wallpaper picker (wallpaper-pick.sh) |

## Timer

| Key | Action |
|-----|--------|
| `Mod+Shift+m` | Timer menu (i3blocks timer) |
Click the time block to open the calendar popup. Use `i3-reminder <minutes> <message>` for desktop reminders.
