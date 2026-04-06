#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
OM_ARCHY_DIR="$HOME/.local/share/omarchy/config/waybar"

exec 2>&1

CHOICE=$(echo -e "Custom\nOmarchy" | walker --dmenu -p "Waybar:" 2>/dev/null)

case "$CHOICE" in
    Omarchy)
        [ ! -f "$WAYBAR_DIR/config.jsoncOM" ] && cp "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/config.jsoncOM" && cp "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/style.cssOM"
        rm -f "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css"
        ln -sf "$OM_ARCHY_DIR/config.jsonc" "$WAYBAR_DIR/config.jsonc"
        ln -sf "$OM_ARCHY_DIR/style.css" "$WAYBAR_DIR/style.css"
        notify-send "Waybar" "Applied Omarchy config" -t 2000
        ;;
    Custom)
        [ -f "$WAYBAR_DIR/config.jsoncOM" ] && rm -f "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css" && cp "$WAYBAR_DIR/config.jsoncOM" "$WAYBAR_DIR/config.jsonc" && cp "$WAYBAR_DIR/style.cssOM" "$WAYBAR_DIR/style.css"
        notify-send "Waybar" "Applied Custom config" -t 2000
        ;;
    *)
        exit 0
        ;;
esac

pkill waybar 2>/dev/null
sleep 0.3
uwsm-app waybar &