#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../" && pwd)"
WALLPAPERS_DIR="$DOTFILES_DIR/wallpapers"
CURRENT_LINK="$HOME/.config/i3/current-wallpaper"

mapfile -d '' -t WALLPAPERS < <(find "$WALLPAPERS_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | sort -z)
TOTAL=${#WALLPAPERS[@]}

if (( TOTAL == 0 )); then
  notify-send "No wallpapers found in $WALLPAPERS_DIR" -t 2000
  exit 1
fi

if [[ -L $CURRENT_LINK ]]; then
  CURRENT=$(readlink "$CURRENT_LINK")
else
  CURRENT=""
fi

INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
  if [[ ${WALLPAPERS[$i]} == "$CURRENT" ]]; then
    INDEX=$i
    break
  fi
done

if (( INDEX == -1 )); then
  NEXT="${WALLPAPERS[0]}"
else
  NEXT="${WALLPAPERS[$(( (INDEX + 1) % TOTAL ))]}"
fi

ln -nsf "$NEXT" "$CURRENT_LINK"
feh --bg-scale "$NEXT"
notify-send "Wallpaper" "$(basename "$NEXT")" -t 1500
