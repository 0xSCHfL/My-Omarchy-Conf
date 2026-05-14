#!/bin/bash

CONFIG="$HOME/.config/i3/config"

parse_bindings() {
  grep '^\s*bindsym' "$CONFIG" | while read -r line; do
    # Extract key combo and command
    key=$(echo "$line" | awk '{print $2}')
    action=$(echo "$line" | cut -d' ' -f3- | sed \
      -e 's/--no-startup-id //' \
      -e 's/exec //' \
      -e "s|$HOME|~|g" \
      -e 's/~/~/')

    # Format modifiers
    key=$(echo "$key" | sed \
      -e 's/Mod4/SUPER/g' \
      -e 's/Mod1/ALT/g' \
      -e 's/shift/SHIFT/g' \
      -e 's/ctrl/CTRL/g' \
      -e 's/\+/ + /g')

    printf "%-35s → %s\n" "$key" "$action"
  done
}

parse_bindings | rofi -dmenu -i -p 'Keybindings'
