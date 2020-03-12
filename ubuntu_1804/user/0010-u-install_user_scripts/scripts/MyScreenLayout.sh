#!/usr/bin/env bash

# Use `cvt` to retrieve the new mode parameters:
# cvt 2560 1440 60
#
# It will returns something similar to:
# Modeline "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync

xrandr --newmode "2560x1440" 312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
xrandr --addmode Virtual1 "2560x1440"
xrandr --output Virtual1 --primary --mode "2560x1440" --pos 0x0 --rotate normal
