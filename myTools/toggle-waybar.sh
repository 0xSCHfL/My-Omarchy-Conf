#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
OM_ARCHY_DIR="$HOME/.local/share/omarchy/config/waybar"

OPTIONS=("Custom" "Omarchy")

CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | gum choose --header "Select waybar config:")

if [ "$CHOICE" = "Omarchy" ]; then
    [ ! -f "$WAYBAR_DIR/config.jsoncOM" ] && cp "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/config.jsoncOM" && cp "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/style.cssOM"
    rm -f "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css"
    ln -sf "$OM_ARCHY_DIR/config.jsonc" "$WAYBAR_DIR/config.jsonc"
    ln -sf "$OM_ARCHY_DIR/style.css" "$WAYBAR_DIR/style.css"
    notify-send "Waybar" "Applied Omarchy config" -t 2000
else
    [ -f "$WAYBAR_DIR/config.jsoncOM" ] && rm -f "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css" && cp "$WAYBAR_DIR/config.jsoncOM" "$WAYBAR_DIR/config.jsonc" && cp "$WAYBAR_DIR/style.cssOM" "$WAYBAR_DIR/style.css"
    notify-send "Waybar" "Applied Custom config" -t 2000
fi

pkill waybar 2>/dev/null
sleep 0.3
uwsm-app waybar &