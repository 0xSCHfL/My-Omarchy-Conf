#!/usr/bin/env bash
set -euo pipefail

playerctl_bin="${PLAYERCTL_BIN:-playerctl}"
rofi_bin="${ROFI_BIN:-rofi}"
rofi_theme="${HOME}/.config/rofi/i3-media-picker.rasi"

if ! command -v "$playerctl_bin" >/dev/null 2>&1 || ! command -v "$rofi_bin" >/dev/null 2>&1; then
  notify-send "Media picker" "playerctl and rofi are required" 2>/dev/null || true
  exit 1
fi

mapfile -t players < <("$playerctl_bin" -l 2>/dev/null | sed '/^[[:space:]]*$/d')

if (( ${#players[@]} == 0 )); then
  notify-send "Media picker" "No media players are available" 2>/dev/null || true
  exit 0
fi

entries=()
for player in "${players[@]}"; do
  status="$("$playerctl_bin" -p "$player" status 2>/dev/null || printf 'Unknown')"
  metadata="$("$playerctl_bin" -p "$player" metadata --format '{{artist}} — {{title}}' 2>/dev/null || true)"
  [[ -n "$metadata" ]] || metadata="No track information"
  entries+=("$player [$status] — $metadata")
done

selected_index="$(
  printf '%s\n' "${entries[@]}" |
    "$rofi_bin" -dmenu -i -no-custom -format i -p "Media" -theme "$rofi_theme"
)"

[[ "$selected_index" =~ ^[0-9]+$ ]] || exit 0
((selected_index < ${#players[@]})) || exit 0

"$playerctl_bin" -p "${players[selected_index]}" play-pause
