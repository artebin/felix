#!/usr/bin/env bash

export SYSTEM_UPDATE_CHECK_STATUS_FILE="/dev/shm/${USER}.system_update_check.status"
export SECURITY_UPDATE_PACKAGE_LIST_FILE="/dev/shm/${USER}.system_update_check.security_update_package_list"

SECURITY_UPDATE_PACKAGE_NAME_ARRAY=""
SECURITY_UPDATE_PACKAGE_COUNT=0

retrieve_security_updates(){
	apt-get -s upgrade | grep -i 'security' | awk -F " " {'print $2'} | uniq > "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	sort -u -o "${SECURITY_UPDATE_PACKAGE_LIST_FILE}" "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	readarray SECURITY_UPDATE_PACKAGE_NAME_ARRAY < <(cat "${SECURITY_UPDATE_PACKAGE_LIST_FILE}")
	SECURITY_UPDATE_PACKAGE_COUNT="${#SECURITY_UPDATE_PACKAGE_NAME_ARRAY[@]}"
}

function system_update_check_exit() {
	YAD_PID=$(cat "${SYSTEM_UPDATE_CHECK_STATUS_FILE}")
	kill -9 "${YAD_PID}"
}
export -f system_update_check_exit

# YAD callback for exiting from the systray
function system_update_check_exit_from_systray() {
	system_update_check_exit
}
export -f system_update_check_exit_from_systray

# YAD callback for button "Install Updates"
function system_update_check_install_security_updates() {
	# Close YAD dialog and change status of security_update_checker: icon in systray is still visible but icon changed because installing updates...
	# Do not use -hold but a "Press <enter> to continue."
	xterm -hold -T "Installing Security Updates ..." -e "cat ${SECURITY_UPDATE_PACKAGE_LIST_FILE} | xargs sudo apt-get install --dry-run"
	# after the end of the xterm, terminate the security_update_checker
}
export -f system_update_check_install_security_updates

# YAD callback for button "Install Updates"
function system_update_check_show_dialog_security_updates() {
	# There is a bug in YAD with the option --center
	# It shows rendering artifacts when resizing the window (blinking windows as centered and modified/resized)
	YAD_DIALOG_GEOMETRY_WIDTH="600"
	YAD_DIALOG_GEOMETRY_HEIGHT="500"
	YAD_DIALOG_GEOMETRY_X="0"
	YAD_DIALOG_GEOMETRY_Y="0"
	
	PRIMARY_MONITOR_GEOMETRY=$(xrandr | grep ' connected primary' | cut -d" " -f4)
	MONITOR_GEOMETRY_REGEX="([0-9]+)x([0-9]+)+([0-9]+)+([0-9]+)"
	if [[ "${PRIMARY_MONITOR_GEOMETRY}" =~ ${MONITOR_GEOMETRY_REGEX} ]]; then
		PRIMARY_MONITOR_WIDTH="${BASH_REMATCH[1]}"
		PRIMARY_MONITOR_HEIGHT="${BASH_REMATCH[2]}"
		PRIMARY_MONITOR_X="${BASH_REMATCH[3]}"
		PRIMARY_MONITOR_Y="${BASH_REMATCH[4]}"
		YAD_DIALOG_GEOMETRY_X=$(( ${PRIMARY_MONITOR_X} + ${PRIMARY_MONITOR_WIDTH} / 2 - ( ${YAD_DIALOG_GEOMETRY_WIDTH} / 2 ) ))
		YAD_DIALOG_GEOMETRY_Y=$(( ${PRIMARY_MONITOR_Y} + ${PRIMARY_MONITOR_HEIGHT} / 2 + ( ${YAD_DIALOG_GEOMETRY_HEIGHT} / 2 ) ))
	fi
	
	yad --list < "${SECURITY_UPDATE_PACKAGE_LIST_FILE}" \
	--column=Package \
	--window-icon="software-update-urgent" \
	--geometry="${YAD_DIALOG_GEOMETRY_WIDTH}x${YAD_DIALOG_GEOMETRY_HEIGHT}+${YAD_DIALOG_GEOMETRY_X}+${YAD_DIALOG_GEOMETRY_Y}" \
	--title="Security Updates Available" \
	--button="Install Updates:bash -c system_update_check_install_security_updates" \
	--button="gtk-close:1" \
	--on-top &
	YAD_DIALOG_PID=$!
	
	# There should be a way to register a callback to run when the YAD window is visible instead of the sleep below
	sleep 0.2
	YAD_DIALOG_WINDOW_ID=$(wmctrl -l | grep -i "Security Updates Available" | awk '{print $1}')
	wmctrl -i -a ${YAD_DIALOG_WINDOW_ID}
}
export -f system_update_check_show_dialog_security_updates

show_yad_systray_notification(){
	yad --notification \
		--listen \
		--image="software-update-urgent" \
		--text="Notification tooltip" \
		--command="bash -c system_update_check_show_dialog_security_updates" \
		--menu="Quit!bash -c system_update_check_exit_from_systray" \
		--no-middle &
	YAD_PID=$!
	echo "${YAD_PID}" >"${SYSTEM_UPDATE_CHECK_STATUS_FILE}"
}

retrieve_security_updates
if [[ "${SECURITY_UPDATE_PACKAGE_COUNT}" != 0 ]]; then
	show_yad_systray_notification
fi
