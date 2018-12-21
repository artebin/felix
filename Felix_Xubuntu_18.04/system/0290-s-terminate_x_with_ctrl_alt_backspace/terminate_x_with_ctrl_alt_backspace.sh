#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

terminate_x_with_ctrl_alt_backspace(){
	cd ${BASEDIR}
	
	echo "Terminate X server with <Ctrl><Alt>Backspace ..."
	cp 90-zap.conf /usr/share/X11/xorg.conf.d/90-zap.conf
	
	echo
}

cd ${BASEDIR}

terminate_x_with_ctrl_alt_backspace 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
