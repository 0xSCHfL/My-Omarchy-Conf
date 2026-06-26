#!/bin/bash
# linphone-popup.sh — Pins the Linphone incoming-call popup to the
# bottom-right corner of the screen, just above the i3bar, and makes
# it sticky so it appears on every workspace.
#
# Why this exists: Linphone-Desktop (especially the AppImage) opens
# its call popup at unpredictable positions and sizes depending on
# the WM. On i3, we want a small (360x220) floating sticky popup in
# the bottom-right corner where it stays visible across workspaces.
#
# Trigger: bind to a key in i3 config (default: Mod4+Shift+l). Or
# run manually:    ./linphone-popup.sh
#
# Screen geometry assumed: 1920x1080. i3bar height ~26px (position
# bottom). Popup: 360x220.

wid=$(xdotool search --classname '^linphone$' 2>/dev/null | tail -1)

if [[ -z "$wid" ]]; then
    echo "No Linphone window found." >&2
    exit 1
fi

# Focus the popup so i3-msg targets the right window.
xdotool windowactivate --sync "$wid" 2>/dev/null

# Configure the popup: floating, sticky (visible on every workspace),
# fixed small size, pinned to bottom-right.
i3-msg "floating enable"
i3-msg "sticky enable"
i3-msg "resize set 360 220"

# Position bottom-right, above the i3bar.
#   screen_w = 1920, screen_h = 1080, bar_h ≈ 26, popup_w = 360, popup_h = 220
#   x = 1920 - 360 - 16 = 1544   (16px right margin)
#   y = 1080 - 220 - 36  = 824   (36px = bar_h + 10px gap)
i3-msg "move absolute position 1544 824"

# Bring to front in case it's behind another window.
xdotool windowraise "$wid" 2>/dev/null
echo "Linphone popup pinned to bottom-right (1544, 824) and sticky."