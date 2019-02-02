#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

update_xdg_user_dirs_default(){
	cd ${BASEDIR}
	
	echo "Remove Templates as a XDG user directory ..."
	XDG_USER_DIRS_DEFAULT_FILE="/etc/xdg/user-dirs.defaults"
	if [[ ! -f "${XDG_USER_DIRS_DEFAULT_FILE}" ]]; then
		echo "Can not find file: ${XDG_USER_DIRS_DEFAULT_FILE}"
	else
		sed -i.bak "s/^TEMPLATES=/#TEMPLATES=/g" "${XDG_USER_DIRS_DEFAULT_FILE}"
	fi
	
	echo
}

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
	
	echo
}

disable_unwanted_xdg_autostart(){
	cd ${BASEDIR}
	
	echo "Disabling unwanted xdg autostart ..."
	
	XDG_AUTOSTART_DESKTOP_FILE_ARRAY=(
		"nm-applet"
		"blueman.desktop"
		"xfce4-power-manager.desktop"
	)
	
	for XDG_AUTOSTART_FILE_NAME in "${XDG_AUTOSTART_DESKTOP_FILE_ARRAY[@]}"; do
		if [[ ! -f "/etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}" ]]; then
			echo "Can not find file: ${XDG_AUTOSTART_FILE_NAME}"
		else
			echo "Disabling autostart for ${XDG_AUTOSTART_FILE_NAME} ..."
			backup_file rename "/etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}"
		fi
	done
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
update_xdg_user_dirs_default 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
list_xdg_autostart_desktop_files 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
disable_unwanted_xdg_autostart 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
