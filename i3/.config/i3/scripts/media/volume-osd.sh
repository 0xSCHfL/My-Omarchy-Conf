#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"
case "$action" in
  up)   pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
  down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
  mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
  *)
    echo "usage: $0 {up|down|mute}" >&2
    exit 1
    ;;
esac

pkill -RTMIN+10 i3blocks

vol="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume/{print $5}' | tr -d '%')"
muted="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"

bar_width=20
filled=$(( vol * bar_width / 100 ))
empty=$(( bar_width - filled ))

if [ "$muted" = "yes" ]; then
  label="Muted"
  bar="$(printf '%*s' "$bar_width" '' | tr ' ' '#')"
  percent=0
else
  label="${vol}%"
  bar="$(printf '%*s' "$filled" '' | tr ' ' '#')$(printf '%*s' "$empty" '' | tr ' ' '-')"
  percent="$vol"
fi

popup_text=$(printf '<span font="Iosevka 14"><b>Volume</b></span>\n<span font="Iosevka 11">%s</span>' "$label")

# YAD displays both the numeric percentage and the progress bar.
if ! command -v yad >/dev/null 2>&1; then
  # xob is the lightweight fallback and is already installed by the i3
  # package set. It displays the same Pywal-colored bar without text.
  if command -v xob >/dev/null 2>&1; then
    xob_config="$HOME/.cache/wal/xob-styles.cfg"
    [ -f "$xob_config" ] || xob_config="$HOME/.config/xob/styles.cfg"
    {
      printf '%s\n' "$percent"
      sleep 1
    } | xob \
      -c "$xob_config" \
      -s volume \
      -m 100 \
      -t 1000 \
      -q
    exit 0
  fi

  # Keep a visible fallback on systems where neither OSD is installed.
  notify-send -u low -h string:x-canonical-private-synchronous:volume-osd \
    "🔊 Volume: $label" "$bar"
  exit 0
fi

{
  printf '%s\n' "$percent"
  sleep 0.8
} | exec yad \
  --progress \
  --title="volume-osd" \
  --text="$popup_text" \
  --progress-text="$bar" \
  --center \
  --fixed \
  --undecorated \
  --on-top \
  --skip-taskbar \
  --width=360 \
  --height=100 \
  --timeout=1 \
  --auto-close \
  --no-buttons \
  --borders=18
