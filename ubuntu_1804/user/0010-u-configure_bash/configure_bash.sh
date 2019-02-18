#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_bash(){
	cd ${BASEDIR}
	
	echo "Configuring bash ..."
	if [ -f ~/.bashrc ]; then
		backup_file rename ~/.bashrc
	fi
	cp ./bashrc ~/.bashrc
	
	echo
}



cd ${BASEDIR}
configure_bash 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
