#!/usr/bin/env bash

source ../../../ubuntu_18.04.sh
is_bash

configure_touchpad_synaptics(){
	cd ${BASEDIR}
	
	echo "Configuring touchpad synaptics ..."
	
	echo "Setting sensitivity ..."
	echo "\nsynclient FingerLow=110 FingerHigh=120 &\n"  >> ~/.config/openbox/autostart
	
	echo
}

cd ${BASEDIR}

configure_touchpad_synaptics 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
