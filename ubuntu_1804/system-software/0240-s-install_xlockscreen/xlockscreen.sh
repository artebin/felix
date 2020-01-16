#!/usr/bin/env bash

# From <https://askubuntu.com/questions/929562/is-there-a-way-to-lock-user-access-on-ubuntu-without-disabling-the-screen>

# The lock timoeout defaults to 15 minutes.
# Enter an argument on the commanline to for a different timeout.
# xptintidle needs to be installed for the script to work

if [[ ! $(type xprintidle 2>/dev/null) ]]; then
	notify-send "xlockscreen cannot be started\nReason: xprintidle is not installed"
	exit
fi
if [[ ! $(type xtrlock 2>/dev/null) ]]; then
	notify-send "xlockscreen cannot be started\nReason: xtrlock is not installed"
	exit
fi
idle=15
[[ "$1" ]] && idle=$1
while :; do
	if (($(xprintidle) > idle * 60000)); then
		[[ $(ps h -C xtrlock) ]] || xtrlock
	fi
	sleep 10
done
