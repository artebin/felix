#!/bin/bash

source ../../common.sh
check_shell

configure_xfce4_power_manager(){
	cd ${BASEDIR}
	
	echo 'Configuring xfce4-power-manager ...'
	xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
}

cd ${BASEDIR}
configure_xfce4_power_manager 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
