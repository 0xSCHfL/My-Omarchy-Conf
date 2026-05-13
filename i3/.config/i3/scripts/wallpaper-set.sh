#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../" && pwd)"
DEFAULT_WALLPAPER="$DOTFILES_DIR/wallpapers/0024.jpg"
WAL_CACHE="$HOME/.cache/wal/wal"

if [[ -n $1 ]]; then
  WALLPAPER="$(realpath "$1")"
elif [[ -f "$WAL_CACHE" ]]; then
  WALLPAPER=$(cat "$WAL_CACHE")
  [[ ! -f "$WALLPAPER" ]] && WALLPAPER="$DEFAULT_WALLPAPER"
else
  WALLPAPER="$DEFAULT_WALLPAPER"
fi

if [[ ! -f "$WALLPAPER" ]]; then
  echo "File does not exist: $WALLPAPER" >&2
  exit 1
fi

feh --bg-scale "$WALLPAPER"
