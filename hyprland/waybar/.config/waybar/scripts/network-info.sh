#!/bin/bash

# Get active interface (ignoring loopback)
active_iface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')

if [ -z "$active_iface" ]; then
  # No active interface found — disconnected
  echo '{"text":"󰤮 Disconnected", "tooltip":"No network connection"}'
  exit 0
fi

# Check if interface is up and has carrier
if ! cat /sys/class/net/$active_iface/operstate 2>/dev/null | grep -q 'up'; then
  echo '{"text":"󰤮 Disconnected", "tooltip":"Interface down"}'
  exit 0
fi

if ! cat /sys/class/net/$active_iface/carrier 2>/dev/null | grep -q '1'; then
  echo '{"text":"󰤮 Disconnected", "tooltip":"No physical connection"}'
  exit 0
fi

# Check interface type (WiFi or Ethernet)
if iw dev "$active_iface" info &>/dev/null; then
  # WiFi interface
  ssid=$(iwgetid -r)
  if [ -z "$ssid" ]; then
    ssid="No SSID"
    icon="󰤮"  # No WiFi connected icon
  else
    icon="󰤯"
  fi
else
  # Ethernet interface
  ssid="$active_iface"
  icon="󰀂"  # Ethernet icon
fi

# Get private IP of active interface
private_ip=$(ip -4 addr show "$active_iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
# Get public IP (optional, slow)
public_ip=$(curl -s https://api.ipify.org)

# Get RX and TX bytes for the interface
rx_bytes=$(cat /sys/class/net/$active_iface/statistics/rx_bytes)
tx_bytes=$(cat /sys/class/net/$active_iface/statistics/tx_bytes)

bytes_to_human() {
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Z,Y}B)
  while ((b > 1024)); do
    d=$(printf ".%02d" $(( (b % 1024) * 100 / 1024 )) )
    b=$(( b / 1024 ))
    ((s++))
  done
  echo "$b$d ${S[$s]}"
}

rx_human=$(bytes_to_human $rx_bytes)
tx_human=$(bytes_to_human $tx_bytes)

echo "{\"text\":\"$icon $ssid\", \"tooltip\":\"Interface: $active_iface\nPrivate IP: $private_ip\nPublic IP: $public_ip\n⇣ $rx_human ⇡ $tx_human\"}"

