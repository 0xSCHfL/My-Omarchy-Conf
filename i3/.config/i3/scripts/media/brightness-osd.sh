#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"
case "$action" in
  up)   brightnessctl set +5% >/dev/null ;;
  down) brightnessctl set 5%- >/dev/null ;;
  max)  brightnessctl set 100% >/dev/null ;;
  min)  brightnessctl set 10%  >/dev/null ;;
  *)
    echo "usage: $0 {up|down|max|min}" >&2
    exit 1
    ;;
esac

# Refresh the i3blocks [brightness] block instantly (matches signal=12)
pkill -RTMIN+12 i3blocks 2>/dev/null || true

# Read current brightness as a percentage
pct="$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')"

bar_width=20
filled=$(( pct * bar_width / 100 ))
empty=$(( bar_width - filled ))

label="${pct}%"
bar="$(printf '%*s' "$filled" '' | tr ' ' '▇')$(printf '%*s' "$empty" '' | tr ' ' '·')"

popup_text=$(printf '<span font="Iosevka 14"><b>Brightness</b></span>\n<span font="Iosevka 11">%s</span>' "$label")

{
  printf '%s\n' "$pct"
  sleep 0.8
} | exec yad \
  --progress \
  --title="brightness-osd" \
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
