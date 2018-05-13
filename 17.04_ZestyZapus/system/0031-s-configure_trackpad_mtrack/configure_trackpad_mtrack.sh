#!/bin/bash

source ../../common.sh
check_shell

configure_trackpad_mtrack(){
	cd ${BASEDIR}
	
	echo "Configuring trackpad mtrack ..."
	
	apt-get install -y xserver-xorg-input-mtrack
	cp ./80-mtrack.conf /usr/share/X11/xorg.conf.d/
}

cd ${BASEDIR}
configure_trackpad_mtrack 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
