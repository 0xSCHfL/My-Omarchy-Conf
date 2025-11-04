#!/bin/bash
# This script gets the public IP and writes it to a file for waybar usage

while true; do
    public_ip=$(curl -s https://api.ipify.org)
    echo "$public_ip" > ~/.config/waybar/public_ip.txt
    sleep 300  # refresh every 5 minutes
done

