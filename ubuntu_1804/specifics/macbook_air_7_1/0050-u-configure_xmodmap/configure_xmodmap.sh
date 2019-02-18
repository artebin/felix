#!/usr/bin/env bash

source ../../../../felix.sh
source ../../../ubuntu_1804.conf
exit_if_not_bash

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
configure_xmodmap 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
