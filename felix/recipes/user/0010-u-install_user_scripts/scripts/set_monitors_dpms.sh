#!/usr/bin/env bash

# The script can be called at login time (graphical login) with a .desktop file like below:
#
# [Desktop Entry]
# Name=Set monitors DPMS
# Type=Application
# Exec=bash -c "bash ${HOME}/scripts/set_monitors_dpms.sh"
# Terminal=false
#

# Disable screensaver
xset -display :0 s 0 0
xset -display :0 s noblank
xset -display :0 s noexpose

# Configure DPMS: completely disable it
xset -display :0 -dpms

# Configure DPMS
#   - Standby: 2 hours
#   - Suspend: 2 hours
#   - Off: never
#xset -display :0 dpms 7200 7200 0
