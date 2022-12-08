#!/usr/bin/env bash

#################################################################################
# DPMS (Display Power Management Signaling) is controlled with the xset command
# See <https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling>
#################################################################################

# Query the current settings
# xset q
#
# Disable screen saver blanking
# xset s off
#
# Change blank time to 1 hour
# xset s 3600 3600
#
# Turn off DPMS
# xset -dpms
#
# Disable DPMS and prevent screen from blanking
# xset s off -dpms
#
# Turn off screen immediately
# xset dpms force off
#
# Standy screen
# xset dpms force standy
#
# Suspend screen
# xset dpms force suspend
#
