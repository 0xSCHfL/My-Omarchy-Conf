#!/usr/bin/env bash
# pin-window.sh — Make the focused window float + sticky (visible on
# every workspace) and re-pin it to the center of the screen at a fixed
# size. You can then drag it wherever you like; it stays sticky and
# floating across workspace switches.
#
# Usage:    pin-window.sh
# Keybind:  Mod+Shift+p (see ~/.config/i3/config)
#
# Reads screen size from xrandr so it works on any monitor resolution.

WIN_W=500
WIN_H=400

wid=$(xdotool getwindowfocus 2>/dev/null)

if [[ -z "$wid" ]]; then
    echo "No focused window." >&2
    exit 1
fi

# Screen dimensions from xrandr (handles multi-monitor; uses the
# first output's current geometry).
read -r SCREEN_W SCREEN_H < <(xrandr --current \
    | awk '/^Screen 0:/ {print $4}' \
    | tr -d ',' \
    | awk -F'x' '{print $1, $2}')

if [[ -z "$SCREEN_W" || -z "$SCREEN_H" ]]; then
    # Fallback to the focused window's monitor
    read -r SCREEN_W SCREEN_H < <(xdotool getdisplaygeometry 2>/dev/null)
fi

if [[ -z "$SCREEN_W" || -z "$SCREEN_H" ]]; then
    echo "Could not determine screen size." >&2
    exit 1
fi

# Floating + sticky first so the resize/move apply to the floating layer.
i3-msg "[id=$wid] floating enable"
i3-msg "[id=$wid] sticky enable"
i3-msg "[id=$wid] resize set $WIN_W $WIN_H"

# Center the window on screen.
pos_x=$(( (SCREEN_W - WIN_W) / 2 ))
pos_y=$(( (SCREEN_H - WIN_H) / 2 ))
i3-msg "[id=$wid] move absolute position $pos_x $pos_y"

xdotool windowraise "$wid" 2>/dev/null

echo "Pinned window $wid: floating, sticky, ${WIN_W}x${WIN_H}, centered at (${pos_x}, ${pos_y})."