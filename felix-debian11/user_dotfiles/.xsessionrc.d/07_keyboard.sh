#!/usr/bin/env bash

# Keyboard should be set properly in /etc/default/keyboard but could also be done here
#setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl &

# Xmodmap
if [[ -f "${HOME}/.Xmodmap" ]]; then
	xmodmap .Xmodmap
fi
