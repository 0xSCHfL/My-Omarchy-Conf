#!/usr/bin/env bash

# i3 VPN Manager - Launch Vortix TUI

if ! command -v vortix >/dev/null 2>&1; then
    alacritty --class i3-vpn -e bash -lc 'printf "vortix is not installed.\nInstall it with: sudo pacman -S vortix\n\n"; read -r -p "Press Enter to close..."'
    exit 1
fi

alacritty --class i3-vpn -e sudo vortix &
