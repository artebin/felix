#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

enable_hibernation(){
	cd ${BASEDIR}
	
	echo "Enabling hibernation ..."
	cat ./com.ubuntu.enable-hibernate.pkla | tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
}

cd ${BASEDIR}
enable_hibernation 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
