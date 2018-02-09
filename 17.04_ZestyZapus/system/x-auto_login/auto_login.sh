#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

AUTO_LOGIN_USER_NAME=''

configure_auto_login(){
	cd ${BASEDIR}
	
	if [ -z ${AUTO_LOGIN_USER_NAME} ]; then
		echo "You should specify a user name for running this script"
		exit 1
	fi
	
	echo "Configuring auto login for user ${AUTO_LOGIN_USER_NAME}"
	if [ -f /etc/lightdm/lightdm.conf.d/50-autologin.conf ]; then
		echo "/etc/lightdm/lightdm.conf.d/50-autologin.conf already exists"
		exit 1
	else
		if [ ! -d /etc/lightdm/lightdm.conf.d ]; then
			mkdir /etc/lightdm/lightdm.conf.d
		fi
		sed -i "/^autologin-user=/s/.*/autologin-user=${AUTO_LOGIN_USER_NAME}/" ./50-autologin.conf
		cp ./50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf
	fi
}

cd ${BASEDIR}
configure_auto_login 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
