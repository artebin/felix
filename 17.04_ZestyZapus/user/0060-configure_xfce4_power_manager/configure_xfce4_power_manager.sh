#!/bin/bash

source ../../common.sh
check_shell

configure_xfce4_power_manager(){
	cd ${BASEDIR}
	
	# Xfce stores its config in ~/.config/xfce4/xfconf/xfce-perchannel-xml/
	# These files should not be changed while logged in xfce (they will be overwritten).
	# Should use xfconf-query applying changes during xfce runtime.
	
	echo "Configuring xfce4-power-manager ..."
	xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
	xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-battery -s 1
	xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-ac -s 1
}

cd ${BASEDIR}
configure_xfce4_power_manager 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
