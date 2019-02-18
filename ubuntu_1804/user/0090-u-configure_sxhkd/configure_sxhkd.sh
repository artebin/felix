#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash

configure_sxhkd(){
	echo "Configuring sxhkd ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/sxhkd
	cp sxhkdrc ~/.config/sxhkd/sxhkdrc
	
	echo
}



cd ${BASEDIR}
configure_sxhkd 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
