#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

blacklist_bluetooth_driver_module(){
	echo "Blacklist bluetooth driver module ..."
	
	echo "blacklist btusb" >> /etc/modprobe.d/blacklist.conf
	
	echo
}

disable_bluetooth_adapter_at_boot_time(){
	echo "Disabling bluetooth adapter at boot time ..."
	
	# See <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup>
	
	echo "Creating '/etc/rc.local' if it does not exist yet ..."
	RC_LOCAL_FILE="/etc/rc.local"
	if [[ ! -f "${RC_LOCAL_FILE}" ]]; then
		touch "${RC_LOCAL_FILE}"
	fi
	
	echo "Disabling bluetooth at startup ..."
	grep -Fxq "rfkill block bluetooth" "${RC_LOCAL_FILE}"
	if [[ $? -eq 0 ]]; then
		echo "${RC_LOCAL_FILE} is already configured with bluetooth adapter disabled"
	else
		backup_file copy "${RC_LOCAL_FILE}"
		echo "rfkill block bluetooth" >> "${RC_LOCAL_FILE}"
	fi
	
	echo
}

blacklist_bluetooth_driver_module 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

disable_bluetooth_adapter_at_boot_time 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
