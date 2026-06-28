#!/usr/bin/env bash
# linphone-popup.sh — Pins the Linphone incoming-call popup to the
# bottom-right corner of the screen, just above the i3bar, and makes
# it sticky so it appears on every workspace.
#
# Why this exists: Linphone-Desktop (especially the AppImage) opens
# its call popup at unpredictable positions and sizes depending on
# the WM. On i3, we want a small (360x220) floating sticky popup in
# the bottom-right corner where it stays visible across workspaces.
#
# This is invoked by linphone-popup-watcher.sh 3 seconds after the
# popup opens, giving you a brief grace period at the popup's
# natural size (so you can see who's calling) before pinning it.

# Find the Linphone popup window. The main app is class
# "linphone.AppImage" with instance "linphone". The popup has class
# "linphone" but is NOT the main app — match by instance.
wid=$(xdotool search --classname '^linphone$' 2>/dev/null \
        | while read w; do
            inst=$(xprop -id "$w" WM_CLASS 2>/dev/null \
                   | grep -oP '"\K[^"]+' | sed -n '2p')
            [[ "$inst" != "linphone.AppImage" ]] && echo "$w"
        done | head -1)

if [[ -z "$wid" ]]; then
    # Fallback: any window titled with call/incoming keywords
    wid=$(xdotool search --name '(?i)(incoming|call|ringing)' 2>/dev/null | head -1)
fi

if [[ -z "$wid" ]]; then
    echo "No Linphone popup window found." >&2
    exit 1
fi

# Read screen dimensions dynamically.
read -r SCREEN_W SCREEN_H < <(xrandr --current \
    | awk '/^Screen 0:/ {gsub(",",""); print $4}' \
    | awk -F'x' '{print $1, $2}')

if [[ -z "$SCREEN_W" || -z "$SCREEN_H" ]]; then
    SCREEN_W=1920
    SCREEN_H=1080
fi

# Fixed popup size.
WIN_W=360
WIN_H=220

# Floating + sticky first so the resize/move apply to the floating layer.
i3-msg "[id=$wid] floating enable"
i3-msg "[id=$wid] sticky enable"
i3-msg "[id=$wid] resize set $WIN_W $WIN_H"

# Position bottom-right, above the i3bar (~26px) with a 10px gap.
pos_x=$(( SCREEN_W - WIN_W - 16 ))
pos_y=$(( SCREEN_H - WIN_H - 36 ))
i3-msg "[id=$wid] move absolute position $pos_x $pos_y"

xdotool windowraise "$wid" 2>/dev/null
echo "Linphone popup pinned: ${WIN_W}x${WIN_H} at (${pos_x}, ${pos_y})."