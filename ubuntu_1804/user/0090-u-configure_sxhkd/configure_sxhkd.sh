#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_sxhkd(){
	echo "Configuring sxhkd ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/sxhkd
	cp sxhkdrc ~/.config/sxhkd/sxhkdrc
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_sxhkd 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
