#!/bin/sh

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

COLS=60
ROWS=18

# Iosevka pixelsize=16 is slightly narrower than Liberation Mono, so the box stays compact.
WW=$(( COLS * 9 ))
WH=$(( ROWS * 20 ))

# Center on the active window (fallback to screen center)
if eval $(xdotool getactivewindow getwindowgeometry --shell 2>/dev/null); then
  CX=$(( X + WIDTH / 2 ))
  CY=$(( Y + HEIGHT / 2 ))
else
  read SW SH <<< $(xdpyinfo 2>/dev/null | awk '/dimensions/{split($2,a,"x"); print a[1], a[2]}')
  [ -z "$SW" ] && SW=1920 && SH=1080
  CX=$(( SW / 2 ))
  CY=$(( SH / 2 ))
fi

X=$(( CX - WW / 2 ))
Y=$(( CY - WH / 2 ))

DIR="${1:-$HOME/Work/dotfiles/wallpapers}"

st \
    -f 'Iosevka:pixelsize=16:antialias=true:autohint=true' \
    -c fzfmenu -n fzfmenu -T fzf \
    -g "${COLS}x${ROWS}+${X}+${Y}" \
    -e "$SCRIPT_DIR/wallpaper-pick-fzf.sh" "$DIR"
