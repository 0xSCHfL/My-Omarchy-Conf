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
  icon="audio-volume-muted"
  bar="$(printf '%*s' "$bar_width" '' | tr ' ' '#')"
  percent=0
else
  label="${vol}%"
  if [ "$vol" -le 33 ]; then
    icon="audio-volume-low"
  elif [ "$vol" -le 66 ]; then
    icon="audio-volume-medium"
  else
    icon="audio-volume-high"
  fi
  bar="$(printf '%*s' "$filled" '' | tr ' ' '#')$(printf '%*s' "$empty" '' | tr ' ' '-')"
  percent="$vol"
fi

popup_text=$(printf '<b><span font="Iosevka 14">Volume</span></b>\n<span font="Iosevka 12">%s</span>' "$label")

screen_width=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ && !found {split($2, size, "x"); print size[1]; found=1}')
screen_height=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ && !found {split($2, size, "x"); print size[2]; found=1}')
screen_width=${screen_width:-1920}
screen_height=${screen_height:-1080}
popup_width=360
popup_height=120
popup_x=$(( (screen_width - popup_width) / 2 ))
popup_y=$(( screen_height - popup_height - 48 ))

# YAD displays the percentage in the label and one clean progress indicator.
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
  sleep 1.8
} | yad \
  --progress \
  --title="volume-osd" \
  --text="$popup_text" \
  --image="$icon" \
  --geometry="${popup_width}x${popup_height}+${popup_x}+${popup_y}" \
  --fixed \
  --undecorated \
  --on-top \
  --skip-taskbar \
  --width=360 \
  --height="$popup_height" \
  --timeout=2 \
  --auto-close \
  --no-buttons \
  --borders=18 || true
