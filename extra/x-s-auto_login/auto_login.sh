#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

AUTO_LOGIN_USER_NAME=''

configure_auto_login(){
	echo "Configuring auto login ..."
	
	if [[ -z "${AUTO_LOGIN_USER_NAME}" ]]; then
		echo "AUTO_LOGIN_USER_NAME should not be empty. Please edit the script and specify a user name."
		exit 1
	fi
	
	echo "AUTO_LOGIN_USER_NAME: ${AUTO_LOGIN_USER_NAME}"
	
	if [[ -d /etc/lightdm/lightdm.conf.d ]]; then
		if [[ -f /etc/lightdm/lightdm.conf.d/50-autologin.conf ]]; then
			echo "/etc/lightdm/lightdm.conf.d/50-autologin.conf already exists"
			exit 1
		fi
	else
		mkdir /etc/lightdm/lightdm.conf.d
	fi
	
	cd "${BASEDIR}"
	sed -i "/^autologin-user=/s/.*/autologin-user=${AUTO_LOGIN_USER_NAME}/" 50-autologin.conf
	cp 50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf
	
	echo
}

configure_auto_login 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
