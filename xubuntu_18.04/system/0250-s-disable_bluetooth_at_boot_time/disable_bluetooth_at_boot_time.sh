#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

blacklist_bluetooth_driver_module(){
	echo "Blacklist bluetooth driver module ..."
	
	echo "blacklist btusb" >> /etc/modprobe.d/blacklist.conf
	
	echo
}

disable_bluetooth_adapter_at_boot_time(){
	echo "Disabling bluetooth adapter at boot time ..."
	
	# See <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup>
	
	# Create '/etc/rc.local' if it does not exists yet
	cd ${BASEDIR}
	RC_LOCAL_FILE="/etc/rc.local"
	if [[ ! -f "${RC_LOCAL_FILE}" ]]; then
		touch "${RC_LOCAL_FILE}"
	fi
	
	# Disable bluetooth at startup
	cd ${BASEDIR}
	grep -Fxq "rfkill block bluetooth" "${RC_LOCAL_FILE}"
	if [[ $? -eq 0 ]]; then
		echo "${RC_LOCAL_FILE} is already configured to disable bluetooth adapter"
	else
		backup_file copy "${RC_LOCAL_FILE}"
		echo "rfkill block bluetooth" >> "${RC_LOCAL_FILE}"
	fi
	
	echo
}

cd ${BASEDIR}
blacklist_bluetooth_driver_module 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
disable_bluetooth_adapter_at_boot_time 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
