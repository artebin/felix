#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_lightdm_greeter(){
	cd ${BASEDIR}
	
	echo "Configuring LightDM greeter ..."
	backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	cp ./lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
}

cd ${BASEDIR}
configure_lightdm_greeter 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
