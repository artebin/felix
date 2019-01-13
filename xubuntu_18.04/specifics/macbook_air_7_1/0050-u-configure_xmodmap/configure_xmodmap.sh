#!/usr/bin/env bash

source ../../../ubuntu_18.04.sh
is_bash

configure_xmodmap(){
	cd ${BASEDIR}
	
	echo "Configuring xmodmap ..."
	if [ -f "~/.xmodmap" ]; then
		backup_file rename ~/.xmodmap
	fi
	
	cp ./Xmodmap ~/.Xmodmap
	echo "xmodmap ~/.Xmodmap" >> ~/.xinitrc
	
	echo
}

cd ${BASEDIR}

configure_xmodmap 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
