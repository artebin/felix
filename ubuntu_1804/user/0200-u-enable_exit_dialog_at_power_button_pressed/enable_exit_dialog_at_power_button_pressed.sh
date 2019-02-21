#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

enable_exit_dialog_at_power_button_pressed(){
	cd ${RECIPE_DIR}
	
	echo "Enabling exit dialog at power button pressed ..."
	cp /etc/systemd/logind.conf ./logind.conf
	add_or_update_line_based_on_prefix "#*HandlePowerKey=" "HandlePowerKey=ignore" ./logind.conf
	sudo cp ./logind.conf /etc/systemd/logind.conf
	# Configuration in openbox rc.xml file should already be done
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -f ./logind.conf
	
	echo
}



cd ${RECIPE_DIR}
enable_exit_dialog_at_power_button_pressed 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
