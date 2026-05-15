#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../" && pwd)"
DEFAULT_WALLPAPER="$DOTFILES_DIR/wallpapers/0024.jpg"
WAL_CACHE="$HOME/.cache/wal/wal"
CURRENT_LINK="$HOME/.config/i3/current-wallpaper"

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

mkdir -p "$(dirname "$CURRENT_LINK")"
ln -nsf "$WALLPAPER" "$CURRENT_LINK"
feh --bg-scale "$WALLPAPER"

if command -v wal >/dev/null 2>&1; then
  wal -q -n -i "$WALLPAPER"
  if [[ -f "$HOME/.cache/wal/colors.sh" ]]; then
    source "$HOME/.cache/wal/colors.sh"
    FLAMESHOT_CONF="$HOME/.config/flameshot/flameshot.ini"
    [[ -f "$FLAMESHOT_CONF" ]] && sed -i "s/^drawColor=.*/drawColor=${color15}/" "$FLAMESHOT_CONF" 2>/dev/null
  fi
fi

if [[ -f "$HOME/.cache/wal/colors.Xresources" ]] && command -v xrdb >/dev/null 2>&1; then
  xrdb -merge "$HOME/.cache/wal/colors.Xresources"
fi

if command -v i3-msg >/dev/null 2>&1; then
  i3-msg reload >/dev/null 2>&1
fi
