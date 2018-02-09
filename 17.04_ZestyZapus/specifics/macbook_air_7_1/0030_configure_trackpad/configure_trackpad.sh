#!/bin/bash

source ../../../common.sh
check_shell

configure_trackpad(){
	cd ${BASEDIR}
	
	echo "Configuring trackpad sensitivity ..."
	echo "synclient FingerLow=110 FingerHigh=120 &"  >> ~/.config/openbox/autostart
}

cd ${BASEDIR}
configure_trackpad 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
