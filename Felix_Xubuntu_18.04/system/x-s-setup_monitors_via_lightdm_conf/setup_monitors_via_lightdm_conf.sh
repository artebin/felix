#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell
exit_if_has_not_root_privileges

setup_monitors_via_lightdm_conf(){
	cd ${BASEDIR}
	
	echo "Setup monitors setup via lightdm configuration ..."
	if [ -f /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh ]; then
		echo "lightdm configuration file /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh already exists!"
		exit 1
	fi
	
	cp ./10-monitors_setup.sh /etc/lightdm/lightdm.conf.d
	
	echo
}

cd ${BASEDIR}

setup_monitors_via_lightdm_conf 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
