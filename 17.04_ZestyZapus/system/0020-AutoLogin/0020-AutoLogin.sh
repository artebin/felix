#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

AUTO_LOGIN_USER_NAME=""

configure_auto_login(){
	cd ${BASEDIR}
	if []; then
		exit 1
	fi
	if [ -f /etc/lightdm/lightdm.conf.d/50-autologin.conf ]; then
		printf "/etc/lightdm/lightdm.conf.d/50-autologin.conf already exists"
	else
		mkdir /etc/lightdm/lightdm.conf.d
		cp ./50-AutoLogin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf
	fi
}

cd ${BASEDIR}
configure_auto_login 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
