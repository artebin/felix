#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash

configure_sxhkd(){
	echo "Configuring sxhkd ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/sxhkd
	cp sxhkdrc ~/.config/sxhkd/sxhkdrc
	
	echo
}

cd ${BASEDIR}
configure_sxhkd 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
