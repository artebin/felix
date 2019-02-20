#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_dmenu(){
	echo "Configuring dmenu ..."
	
	if [[ -d ~/.config/dmenu ]]; then
		backup_file rename ~/.config/dmenu
	fi
	mkdir -p ~/.config/dmenu
	cd "${BASEDIR}"
	cp dmenu-bind.sh ~/.config/dmenu
	chmod +x ~/.config/dmenu/dmenu-bind.sh
	
	echo
}

cd "${BASEDIR}"
configure_dmenu 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
