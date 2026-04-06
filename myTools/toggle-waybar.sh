#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
OM_ARCHY_DIR="$HOME/.local/share/omarchy/config/waybar"

# Check current state
CURRENT_CONFIG=$(readlink -f "$WAYBAR_DIR/config.jsonc" 2>/dev/null)
OMARCHY_CONFIG=$(realpath "$OM_ARCHY_DIR/config.jsonc")

if [ "$CURRENT_CONFIG" = "$OMARCHY_CONFIG" ]; then
    # Currently using omarchy config - switch to custom
    if [ ! -f "$WAYBAR_DIR/config.jsoncOM" ]; then
        cp "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/config.jsoncOM"
        cp "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/style.cssOM"
    fi
    rm "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css"
    cp "$WAYBAR_DIR/config.jsoncOM" "$WAYBAR_DIR/config.jsonc"
    cp "$WAYBAR_DIR/style.cssOM" "$WAYBAR_DIR/style.css"
    echo "Switched to custom waybar config"
else
    # Currently using custom config - switch to omarchy
    if [ ! -f "$WAYBAR_DIR/config.jsoncOM" ]; then
        cp "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/config.jsoncOM"
        cp "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/style.cssOM"
    fi
    rm "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css"
    ln -sf "$OM_ARCHY_DIR/config.jsonc" "$WAYBAR_DIR/config.jsonc"
    ln -sf "$OM_ARCHY_DIR/style.css" "$WAYBAR_DIR/style.css"
    echo "Switched to omarchy waybar config"
fi

pkill waybar && waybar &