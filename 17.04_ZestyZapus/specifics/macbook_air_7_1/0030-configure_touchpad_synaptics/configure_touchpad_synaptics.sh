#!/bin/bash

source ../../../common.sh
check_shell

configure_touchpad_synaptics(){
	cd ${BASEDIR}
	
	echo "Configuring touchpad synaptics ..."
	
	echo "Setting sensitivity ..."
	echo "synclient FingerLow=110 FingerHigh=120 &"  >> ~/.config/openbox/autostart
}

cd ${BASEDIR}
configure_touchpad_synaptics 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
