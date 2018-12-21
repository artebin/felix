#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell
exit_if_has_not_root_privileges

disable_bluetooth_adapter_at_boot_time(){
	cd ${BASEDIR}
	
	echo "Disabling bluetooth adapter at boot time ..."
	
	# See <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup>
	
	RC_LOCAL_FILE="/etc/rc.local"
	if [[ ! -f "${RC_LOCAL_FILE}" ]]; then
		touch "${RC_LOCAL_FILE}"
	fi
	
	# Check if bluetooth already disabled
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

disable_bluetooth_adapter_at_boot_time 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
