#!/usr/bin/env bash

print_usage(){
	printf "Usage: ${0} [OPTIONS...]\n"
	printf "  -s     check security updates only\n"
	printf "\n"
}

add_or_update_keyvalue(){
	FILE_PATH="${1}"
	KEY="${2}"
	NEW_VALUE="${3}"
	if grep -q "^${KEY}" "${FILE_PATH}"; then
		sed -i "/^${KEY}=/s/.*/${KEY}=${NEW_VALUE}/" "${FILE_PATH}"
	else
		echo "${KEY}=${NEW_VALUE}" >> "${FILE_PATH}"
	fi
}

export SYSTEM_UPDATE_CHECK_STATUS_FILE="/dev/shm/${USER}.system_update_check.status"
export NOT_SECURITY_UPDATE_PACKAGE_LIST_FILE="/dev/shm/${USER}.system_update_check.not_security_update_package_list"
export SECURITY_UPDATE_PACKAGE_LIST_FILE="/dev/shm/${USER}.system_update_check.security_update_package_list"

SECURITY_UPDATE_PACKAGE_NAME_ARRAY=""
SECURITY_UPDATE_PACKAGE_COUNT=0

retrieve_security_updates(){
	# TODO: grepping below is not correct to retrieve security updates only
	# Follow <https://wiki.debian.org/SourcesList>
	# The updates treated as "security updates" should be be ones provided by a list of (distribution,component)
	# See <https://askubuntu.com/questions/401941/what-is-the-difference-between-security-updates-proposed-and-backports-in-etc> for Ubuntu sources
	apt-get -s upgrade | grep -i 'security' | awk -F " " {'print $2'} | uniq > "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	sort -u -o "${SECURITY_UPDATE_PACKAGE_LIST_FILE}" "${SECURITY_UPDATE_PACKAGE_LIST_FILE}"
	readarray SECURITY_UPDATE_PACKAGE_NAME_ARRAY < <(cat "${SECURITY_UPDATE_PACKAGE_LIST_FILE}")
	SECURITY_UPDATE_PACKAGE_COUNT="${#SECURITY_UPDATE_PACKAGE_NAME_ARRAY[@]}"
}

function system_update_check_exit() {
	YAD_NOTIFICATION_PID=$(crudini --get "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_NOTIFICATION_PID")
	kill -9 "${YAD_NOTIFICATION_PID}"
}
export -f system_update_check_exit

# YAD callback for exiting from the systray
function system_update_check_exit_from_systray() {
	system_update_check_exit
}
export -f system_update_check_exit_from_systray

# YAD callback for button "Install Updates"
function system_update_check_install_security_updates() {
	xterm -T "Installing Security Updates ..." -e "cat ${SECURITY_UPDATE_PACKAGE_LIST_FILE} | xargs sudo apt-get install --dry-run;printf '\n\n';read -p 'Press enter to exit.'" &
	
	# Close YAD dialog and change status of security_update_checker: icon in systray is still visible but icon changed because installing updates...
	YAD_DIALOG_PID=$(crudini --get "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_DIALOG_PID" 2>/dev/null)
	if [[ ! -z "${YAD_DIALOG_PID}" ]]; then
		kill -9 "${YAD_DIALOG_PID}"
		crudini --del "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_DIALOG_PID"
		return
	fi
	
	# after the end of the xterm, terminate the security_update_checker
}
export -f system_update_check_install_security_updates

# YAD callback for button "Install Updates"
function system_update_check_show_dialog_security_updates() {
	YAD_DIALOG_PID=$(crudini --get "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_DIALOG_PID" 2>/dev/null)
	if [[ ! -z "${YAD_DIALOG_PID}" ]]; then
		kill -9 "${YAD_DIALOG_PID}"
		crudini --del "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_DIALOG_PID"
		return
	fi
	
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
	crudini --set "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_DIALOG_PID" "${YAD_DIALOG_PID}"
	
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
		--text="${SECURITY_UPDATE_PACKAGE_COUNT} security updates available" \
		--command="bash -c system_update_check_show_dialog_security_updates" \
		--menu="Quit!bash -c system_update_check_exit_from_systray" \
		--no-middle &
	YAD_NOTIFICATION_PID=$!
	crudini --set "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "YAD_NOTIFICATION_PID" "${YAD_NOTIFICATION_PID}"
}

# Retrieve options
CHECK_SECURITY_UPDATES_ONLY="false"
while getopts "s" OPT; do
	case "${OPT}" in
		s)
			CHECK_SECURITY_UPDATES_ONLY="true"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

# Get lock on SYSTEM_UPDATE_CHECK_STATUS_FILE 
exec 100>"${SYSTEM_UPDATE_CHECK_STATUS_FILE}"
flock -n 100
if [[ $? -ne 0 ]]; then
	printf "$0 is already running\n\n"
	exit 1
fi
crudini --set "${SYSTEM_UPDATE_CHECK_STATUS_FILE}" "General" "SYSTEM_UPDATE_CHECK_PID" "$$"

retrieve_security_updates
#if ! ${CHECK_SECURITY_UPDATES_ONLY}; then
#	
#fi

if [[ "${SECURITY_UPDATE_PACKAGE_COUNT}" != 0 ]]; then
	show_yad_systray_notification
fi
