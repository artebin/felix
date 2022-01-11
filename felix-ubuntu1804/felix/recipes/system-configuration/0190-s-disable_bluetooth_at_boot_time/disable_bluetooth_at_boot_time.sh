#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

blacklist_bluetooth_driver_module(){
	printf "Blacklist bluetooth driver module...\n"
	
	printf "blacklist btusb\n" >> /etc/modprobe.d/blacklist.conf
	
	printf "\n"
}

disable_bluetooth_adapter_at_boot_time(){
	printf "Disabling bluetooth adapter at boot time...\n"
	
	# See <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup>
	
	printf "Creating '/etc/rc.local' if it does not exist yet...\n"
	RC_LOCAL_FILE="/etc/rc.local"
	if [[ ! -f "${RC_LOCAL_FILE}" ]]; then
		touch "${RC_LOCAL_FILE}"
	fi
	
	printf "Disabling bluetooth at startup...\n"
	grep -Fxq "rfkill block bluetooth" "${RC_LOCAL_FILE}"
	if [[ $? -eq 0 ]]; then
		printf "${RC_LOCAL_FILE} is already configured with bluetooth adapter disabled\n"
	else
		backup_file copy "${RC_LOCAL_FILE}"
		printf "rfkill block bluetooth\n" >> "${RC_LOCAL_FILE}"
	fi
	
	printf "\n"
}

blacklist_bluetooth_driver_module 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

disable_bluetooth_adapter_at_boot_time 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
