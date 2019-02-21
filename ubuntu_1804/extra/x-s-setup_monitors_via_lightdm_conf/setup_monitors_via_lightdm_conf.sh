#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

setup_monitors_via_lightdm_conf(){
	echo "Setup monitors setup via lightdm configuration ..."
	
	if [[ -f /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh ]]; then
		echo "lightdm configuration file /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh already exists!"
		exit 1
	fi
	
	cd "${BASEDIR}"
	cp 10-monitors_setup.sh /etc/lightdm/lightdm.conf.d
	
	echo
}

setup_monitors_via_lightdm_conf 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
