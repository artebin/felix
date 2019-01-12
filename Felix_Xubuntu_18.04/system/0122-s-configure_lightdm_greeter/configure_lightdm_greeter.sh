#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

configure_lightdm_greeter(){
	cd ${BASEDIR}
	
	echo "Configuring LightDM greeter ..."
	backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	cp ./lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
	
	echo
}

cd ${BASEDIR}

configure_lightdm_greeter 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
