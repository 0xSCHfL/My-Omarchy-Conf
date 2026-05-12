#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../" && pwd)"
WALLPAPERS_DIR="$DOTFILES_DIR/wallpapers"
CURRENT_LINK="$HOME/.config/i3/current-wallpaper"

SELECTED=$(find "$WALLPAPERS_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort | rofi -dmenu -l 20 -p "Wallpaper" -theme-str 'window { width: 40%; location: center; anchor: center; }')

if [[ -n "$SELECTED" ]]; then
  ln -nsf "$SELECTED" "$CURRENT_LINK"
  feh --bg-scale "$SELECTED"
  notify-send "Wallpaper" "$(basename "$SELECTED")" -t 1500
fi
