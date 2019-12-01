#!/usr/bin/env bash

# Handler to process the shutdown
function on_exit() {
	PID=$(cat /tmp/system_update_notification.yad)
	kill -9 $PID
}
export -f on_exit

# Handler for tray icon left click
function on_click_left() {
	echo "clicked"
}
export -f on_click_left

# Handler for menu item "quit"
function menu_item_quit() {
	on_exit
}

# create the notification icon
yad --notification \
	--listen \
	--image="gtk-help" \
	--text="Notification tooltip" \
	--command="bash -c on_click_left" \
	--menu="Quit!bash -c on_exit" \
	--no-middle &

YAD_PID=$!
echo "$YAD_PID" >/tmp/system_update_notification.yad
