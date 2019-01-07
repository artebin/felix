#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash

enable_exit_dialog_at_power_button_pressed(){
	cd ${BASEDIR}
	
	echo "Enabling exit dialog at power button pressed ..."
	cp /etc/systemd/logind.conf ./logind.conf
	add_or_update_line_based_on_prefix "#*HandlePowerKey=" "HandlePowerKey=ignore" ./logind.conf
	sudo cp ./logind.conf /etc/systemd/logind.conf
	# Configuration in openbox rc.xml file should already be done
	
	# Cleaning
	cd ${BASEDIR}
	rm -f ./logind.conf
	
	echo
}

cd ${BASEDIR}

enable_exit_dialog_at_power_button_pressed 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
