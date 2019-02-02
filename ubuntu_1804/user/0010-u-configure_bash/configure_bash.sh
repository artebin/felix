#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_bash(){
	cd ${BASEDIR}
	
	echo "Configuring bash ..."
	if [ -f ~/.bashrc ]; then
		backup_file rename ~/.bashrc
	fi
	cp ./bashrc ~/.bashrc
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_bash 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
