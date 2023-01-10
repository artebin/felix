#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

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
		mkdir -p /etc/lightdm/lightdm.conf.d
	fi
	
	cd "${RECIPE_DIRECTORY}"
	sed -i "/^autologin-user=/s/.*/autologin-user=${AUTO_LOGIN_USER_NAME}/" 50-autologin.conf
	cp 50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf
	
	echo
}

configure_auto_login 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
