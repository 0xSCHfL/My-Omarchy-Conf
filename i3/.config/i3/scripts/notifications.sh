#!/bin/bash

set -euo pipefail

theme="$HOME/.config/rofi/i3-launcher.rasi"

choice=$(
  python3 - <<'PY' | rofi -dmenu -i -p "Notifications" -theme "$HOME/.config/rofi/i3-launcher.rasi"
import subprocess

def run(*args):
    return subprocess.run(args, capture_output=True, text=True).stdout.strip()

paused = run("dunstctl", "is-paused")
history = run("dunstctl", "count", "history") or "0"
displayed = run("dunstctl", "count", "displayed") or "0"

items = [
    f"{'Resume notifications' if paused == 'true' else 'Pause notifications'}",
    f"Notification history ({history})",
    f"Close visible notifications ({displayed})",
    "Pop last notification",
    "Clear notification history",
]
print("\n".join(items))
PY
)

[ -n "${choice:-}" ] || exit 0

case "$choice" in
  "Pause notifications"|"Resume notifications")
    dunstctl set-paused toggle
    ;;
  "Notification history ("*)
    selected_id=$(
      dunstctl history | python3 - <<'PY' | rofi -dmenu -i -p "History" -theme "$HOME/.config/rofi/i3-launcher.rasi" | cut -f1
import json
import sys

try:
    items = json.load(sys.stdin)
except json.JSONDecodeError:
    items = []

lines = []
for item in reversed(items):
    ident = str(item.get("id", ""))
    summary = " ".join(str(item.get("summary", "")).split())
    body = " ".join(str(item.get("body", "")).split())
    text = summary or body or "[no text]"
    if body and body != summary:
      text = f"{summary} - {body}" if summary else body
    lines.append(f"{ident}\t{text}")

print("\n".join(lines))
PY
    )
    [ -n "${selected_id:-}" ] && dunstctl history-pop "$selected_id"
    ;;
  "Close visible notifications ("*)
    dunstctl close-all
    ;;
  "Pop last notification")
    dunstctl history-pop
    ;;
  "Clear notification history")
    dunstctl history-clear
    ;;
esac
