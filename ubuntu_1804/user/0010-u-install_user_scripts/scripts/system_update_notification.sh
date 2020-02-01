#!/usr/bin/env bash

export SYSTEM_UPDATE_UI_STATUS_FILE="/dev/shm/${USER}.system_update_ui.status"
export SECURITY_UPDATE_PACKAGE_LIST_FILE="/dev/shm/${USER}.system_update_package.list"

SECURITY_UPDATE_PACKAGE_NAME_ARRAY=""
SECURITY_UPDATE_PACKAGE_COUNT=0

retrieve_security_updates(){
	apt-get -s upgrade | grep -i 'security' | awk -F " " {'print $2'} | uniq > "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	sort -u -o "${SECURITY_UPDATE_PACKAGE_LIST_FILE}" "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	readarray SECURITY_UPDATE_PACKAGE_NAME_ARRAY < <(cat "${SECURITY_UPDATE_PACKAGE_LIST_FILE}")
	SECURITY_UPDATE_PACKAGE_COUNT="${#SECURITY_UPDATE_PACKAGE_NAME_ARRAY[@]}"
}

# Handler to process yad shutdown
function system_update_notification_exit() {
	YAD_PID=$(cat "${SYSTEM_UPDATE_UI_STATUS_FILE}")
	kill -9 "${YAD_PID}"
}
export -f system_update_notification_exit

# Handler for tray icon left click
function system_update_notification_click_left() {
	yad --list < "${SECURITY_UPDATE_PACKAGE_LIST_FILE}" \
	--column=Package \
	--window-icon="software-update-urgent" \
	--width=600 \
	--height=500 \
	--wrap \
	--title="Security Updates Available" \
	--button="Install Updates:0" \
	--button="gtk-close:1" \
	--on-top &
	YAD_DIALOG_PID=$!
	# There should be a way to register a callback to run when the YAD window is visible instead of the sleep below
	sleep 0.2
	YAD_DIALOG_WINDOW_ID=$(wmctrl -l | grep -i "Security Updates Available" | awk '{print $1}')
	wmctrl -i -a ${YAD_DIALOG_WINDOW_ID}
}
export -f system_update_notification_click_left

# Handler for menu item "quit"
function system_update_notification_menu_item_quit() {
	system_update_notification_exit
}
export -f system_update_notification_menu_item_quit

start_yad_notification(){
	yad --notification \
		--listen \
		--image="software-update-urgent" \
		--text="Notification tooltip" \
		--command="bash -c system_update_notification_click_left" \
		--menu="Quit!bash -c system_update_notification_menu_item_quit" \
		--no-middle &
	YAD_PID=$!
	echo "${YAD_PID}" >"${SYSTEM_UPDATE_UI_STATUS_FILE}"
}

retrieve_security_updates
if [[ "${SECURITY_UPDATE_PACKAGE_COUNT}" != 0 ]]; then
	start_yad_notification
fi
