#!/bin/sh

DIR="${1:-$HOME/Work/dotfiles/wallpapers}"

case "$(uname -a)" in *Darwin*) T="/tmp" ;; *) T="/tmp" ;; esac

cleanup() { ueberzugpp cmd -s "$SOCKET" -a exit; }
trap cleanup HUP INT QUIT TERM EXIT

PID_FILE="$T/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --pid-file "$PID_FILE"
while [ ! -s "$PID_FILE" ]; do sleep 0.05; done
SOCKET="$T"/ueberzugpp-"$(cat "$PID_FILE")".socket

SELECTED=$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort | \
  fzf --reverse --delimiter / --with-nth -1 \
    --preview="ueberzugpp cmd -s $SOCKET -i p -a add \
      -x \$FZF_PREVIEW_LEFT -y \$FZF_PREVIEW_TOP \
      --max-width \$FZF_PREVIEW_COLUMNS --max-height \$FZF_PREVIEW_LINES -f {}")

ueberzugpp cmd -s "$SOCKET" -a exit

if [ -n "$SELECTED" ]; then
  "$(CDPATH= cd -- "$(dirname "$0")" && pwd)"/wallpaper-set.sh --no-wal "$SELECTED"
fi
