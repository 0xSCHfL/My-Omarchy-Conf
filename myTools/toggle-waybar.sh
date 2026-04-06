#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
OM_ARCHY_DIR="$HOME/.local/share/omarchy/config/waybar"
DOTFILES_DIR="$HOME/Work/dotfiles/waybar/.config/waybar"

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
        rm -f "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/style.css"
        cp "$DOTFILES_DIR/config.jsonc" "$WAYBAR_DIR/config.jsonc"
        cp "$DOTFILES_DIR/style.css" "$WAYBAR_DIR/style.css"
        notify-send "Waybar" "Applied Custom config" -t 2000
        ;;
    *)
        exit 0
        ;;
esac

pkill waybar
sleep 1
uwsm-app waybar &