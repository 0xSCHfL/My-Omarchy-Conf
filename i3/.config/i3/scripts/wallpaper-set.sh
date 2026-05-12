#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../" && pwd)"
DEFAULT_WALLPAPER="$DOTFILES_DIR/wallpapers/0024.jpg"

if [[ -z $1 ]]; then
  WALLPAPER="$DEFAULT_WALLPAPER"
else
  WALLPAPER="$(realpath "$1")"
fi

CURRENT_LINK="$HOME/.config/i3/current-wallpaper"

if [[ ! -f "$WALLPAPER" ]]; then
  echo "File does not exist: $WALLPAPER" >&2
  exit 1
fi

ln -nsf "$WALLPAPER" "$CURRENT_LINK"
feh --bg-scale "$WALLPAPER"
