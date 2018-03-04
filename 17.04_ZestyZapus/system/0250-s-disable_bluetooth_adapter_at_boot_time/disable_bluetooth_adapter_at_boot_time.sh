#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

disable_bluetooth_adapter_at_boot_time(){
	cd ${BASEDIR}
	
	echo "Disabling bluetooth adapter at boot time ..."
	
	# See <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup>
	
	if [ -f /etc/rc/local ]; then
		# Check if bluetooth already disabled
		grep -Fxq "rfkill block bluetooth" /etc/rc.local
		if [ $? -eq 1 ]; then
			backup_file copy /root/.bashrc
			echo "rfkill block bluetooth" >> /etc/rc.local
		fi
	else
		echo "rfkill block bluetooth" > /etc/rc.local
	fi
}

cd ${BASEDIR}
disable_bluetooth_adapter_at_boot_time 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
