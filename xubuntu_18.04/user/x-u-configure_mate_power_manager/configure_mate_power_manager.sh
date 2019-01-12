#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash

configure_mate_power_manager(){
	cd ${BASEDIR}
	
	echo "Configuring mate-power-manager ..."
	
	# Use `dconf dump /org/mate/power-manager/ >org.mate.power-manager.dump` for retrieving configuration
	dconf load /org/mate/power-manager/ < ./org.mate.power-manager.dump
	
	echo
}

cd ${BASEDIR}

configure_mate_power_manager 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
