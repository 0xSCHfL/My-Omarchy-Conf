#!/bin/bash

# Simple PyWal wallpaper script
# This uses PyWal's proven functionality instead of fighting against it

WALLPAPER="$1"

if [ -z "$WALLPAPER" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

# Run PyWal to generate colors from wallpaper
# PyWal will:
# 1. Extract colors from the wallpaper
# 2. Generate ~/.cache/wal/colors-kitty.conf
# 3. Apply colors to all supported applications (including Kitty)
# 4. Set the desktop background
wal -i "$WALLPAPER" -q

echo "Wallpaper and colors updated: $(basename "$WALLPAPER")"