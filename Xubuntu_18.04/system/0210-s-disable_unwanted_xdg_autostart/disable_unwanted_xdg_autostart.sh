#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

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
disable_unwanted_xdg_autostart 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
