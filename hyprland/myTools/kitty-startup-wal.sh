#!/bin/bash

# Auto-run PyWal on Kitty startup
# Uses the current omarchy background

CURRENT_BG_LINK="$HOME/.config/omarchy/current/background"

if [[ -L "$CURRENT_BG_LINK" ]]; then
    CURRENT_BG=$(readlink "$CURRENT_BG_LINK")
    
    # Generate colors from current wallpaper
    wal -i "$CURRENT_BG" -q
    
    echo "Kitty startup: Colors set from $(basename "$CURRENT_BG")"
else
    echo "No current wallpaper found, using default colors"
fi