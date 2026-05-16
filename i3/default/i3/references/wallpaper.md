# Wallpaper & Pywal

## Wallpaper

- Restored from `~/.cache/wal/wal` on startup (last pywal selection)
- Default: `../wallpapers/0024.jpg`
- Pick via Rofi with `Super+Ctrl+Space`
- Set with pywal via `Super+Shift+i` → select image → `Alt+w`

## Pywal in terminals

- **kitty**: includes `~/.cache/wal/colors-kitty.conf` directly
- **tmux**: `.zshrc` runs `cat ~/.cache/wal/sequences` at startup to set tmux palette
- **i3**: `wallpaper-set.sh` runs `wal -i <image>` on wallpaper change, also calls `xrdb -merge colors.Xresources`

## Wallpaper scripts

| Script | Path | Purpose |
|--------|------|---------|
| `wallpaper-set.sh` | `.config/i3/scripts/wallpaper/wallpaper-set.sh` | Set wallpaper, run pywal, update Xresources |
| `wallpaper-pick.sh` | `.config/i3/scripts/wallpaper/wallpaper-pick.sh` | Rofi-based wallpaper picker |
| `wallpaper-next.sh` | `.config/i3/scripts/wallpaper/wallpaper-next.sh` | Cycle to next wallpaper |
