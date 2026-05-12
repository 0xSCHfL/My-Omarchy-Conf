#!/bin/bash

active_iface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')

if [ -z "$active_iface" ]; then
    echo "󰤮 Disconnected"
    exit 0
fi

if iw dev "$active_iface" info &>/dev/null; then
    ssid=$(iwgetid -r)
    [ -z "$ssid" ] && echo "󰤮 No SSID" || echo "󰤯 $ssid"
else
    ip=$(ip -4 addr show "$active_iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "󰀂 $ip"
fi
