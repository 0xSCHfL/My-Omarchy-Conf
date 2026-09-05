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
    "Change notification sound",
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
  "Change notification sound")
    i3-notification-sound-picker
    ;;
  "Notification history ("*)
    selected_id=$(
      history_json="$(dunstctl history)"
      printf '%s' "$history_json" | python3 -c '
import json
import sys

try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

# dunstctl 1.13 returns a typed D-Bus value: {"data": [[{...}]]}.
# Keep this tolerant of older/plain-list output as well.
data = payload.get("data", []) if isinstance(payload, dict) else payload
items = data[0] if data and isinstance(data[0], list) else data

def value(item, name):
    field = item.get(name, "") if isinstance(item, dict) else ""
    return field.get("data", "") if isinstance(field, dict) else field

lines = []
for item in reversed(items or []):
    ident = str(value(item, "id"))
    summary = " ".join(str(value(item, "summary")).split())
    body = " ".join(str(value(item, "body")).split())
    text = summary or body or "[no text]"
    if body and body != summary:
        text = f"{summary} - {body}" if summary else body
    lines.append(f"{ident}\t{text}")

print("\n".join(lines))
' | rofi -dmenu -i -p "History" -theme "$HOME/.config/rofi/i3-launcher.rasi" | cut -f1
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
