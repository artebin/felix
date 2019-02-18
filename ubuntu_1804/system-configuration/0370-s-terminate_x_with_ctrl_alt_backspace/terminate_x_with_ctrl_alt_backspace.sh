#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

terminate_x_with_ctrl_alt_backspace(){
	cd ${BASEDIR}
	
	echo "Terminate X server with <Ctrl><Alt>Backspace ..."
	cp 90-zap.conf /usr/share/X11/xorg.conf.d/90-zap.conf
	
	echo
}



cd ${BASEDIR}
terminate_x_with_ctrl_alt_backspace 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
