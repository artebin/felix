#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_dmenu(){
	cd ${BASEDIR}
	
	echo "Configuring dmenu ..."
	if [ -f ~/.config/dmenu ]; then
		backup_file rename ~/.config/dmenu
	fi
	if [ ! -f ~/.config/dmenu ]; then
		mkdir -p ~/.config/dmenu
	fi
	cp ./dmenu-bind.sh ~/.config/dmenu
	chmod +x ~/.config/dmenu/dmenu-bind.sh
	
	echo
}



cd ${BASEDIR}
configure_dmenu 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
