#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

list_xdg_autostart_desktop_files(){
	cd ${BASEDIR}
	
	DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY=()
	declare -A DESKTOP_ONLYSHOWIN_MAP
	
	for DESKTOP_FILE in /etc/xdg/autostart/*.desktop; do
		ONLYSHOWIN_LINE=$(cat ${DESKTOP_FILE}|grep "^OnlyShowIn=")
		if [[ -z "${ONLYSHOWIN_LINE}" ]]; then
			DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY+=( "${DESKTOP_FILE}" )
		else
			ONLYSHOWIN_LINE=$(echo "${ONLYSHOWIN_LINE}"|sed 's/^OnlyShowIn=//g')
			DESKTOP_ARRAY=( $(echo "${ONLYSHOWIN_LINE}"|sed 's/;/ /g') )
			for DESKTOP_NAME in "${DESKTOP_ARRAY[@]}"; do
				DESKTOP_ONLYSHOWIN_MAP["${DESKTOP_NAME}"]+=" ${DESKTOP_FILE}"
			done
		fi
	done
	
	echo "Desktop files for all desktops:"
	for DESKTOP_FILE in "${DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY[@]}"; do
		echo "  ${DESKTOP_FILE}"
	done
	
	echo
	
	for DESKTOP_NAME in "${!DESKTOP_ONLYSHOWIN_MAP[@]}"; do
		echo "Desktop files for ${DESKTOP_NAME}:"
		DESKTOP_FILE_ARRAY=( ${DESKTOP_ONLYSHOWIN_MAP[${DESKTOP_NAME}]} )
		for DESKTOP_FILE in "${DESKTOP_FILE_ARRAY[@]}"; do
			echo "  ${DESKTOP_FILE}"
		done
		echo
	done
}

disable_unwanted_xdg_autostart(){
	cd ${BASEDIR}
	
	echo "Disabling unwanted xdg autostart ..."
	
	XDG_AUTOSTART_DESKTOP_FILE_ARRAY=(
		blueman.desktop
	)
	
	for XDG_AUTOSTART_FILE_NAME in "${XDG_AUTOSTART_DESKTOP_FILE_ARRAY[@]}"; do
		if [[ ! -f "${XDG_AUTOSTART_FILE_NAME}" ]]; then
			echo "Can not find file: ${XDG_AUTOSTART_FILE_NAME}"
		else
			echo "Disabling autostart for ${XDG_AUTOSTART_FILE_NAME} ..."
			backup_file rename "/etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}"
		fi
	done
}

cd ${BASEDIR}
list_xdg_autostart_desktop_files
disable_unwanted_xdg_autostart 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
