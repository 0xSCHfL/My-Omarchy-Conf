#!/bin/bash

# i3 WiFi Manager - Launch Impala TUI

rfkill unblock wifi
exec alacritty --class i3-wifi -e impala
