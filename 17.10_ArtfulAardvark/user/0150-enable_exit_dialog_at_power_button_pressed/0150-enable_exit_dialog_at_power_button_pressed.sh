#!/bin/bash

source ../../common.sh
check_shell

enable_exit_dialog_at_power_button_pressed(){
	cd ${BASEDIR}
	
	echo 'Enabling exit dialog at power button pressed ...'
	add_or_update_line_based_on_prefix "#HandlePowerKey=" "HandlePowerKey=ignore" "/etc/systemd/logind.conf"
	# Configuration in openbox rc.xml file should already be done
}

cd ${BASEDIR}
enable_exit_dialog_at_power_button_pressed 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
