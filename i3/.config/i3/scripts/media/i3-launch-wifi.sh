#!/bin/bash

# i3 WiFi Manager - Launch Impala TUI

rfkill unblock wifi 2>/dev/null
alacritty --class i3-wifi -e impala &
