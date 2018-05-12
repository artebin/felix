#!/bin/bash

source ../../common.sh
check_shell

configure_mate_power_manager(){
	cd ${BASEDIR}
	
	echo "Configuring mate-power-manager ..."
	
	# Use `dconf dump /org/mate/power-manager/ >org.mate.power-manager.dump` for retrieving configuration
	dconf load /org/mate/power-manager/ < ./org.mate.power-manager.dump
}

cd ${BASEDIR}
configure_mate_power_manager 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
