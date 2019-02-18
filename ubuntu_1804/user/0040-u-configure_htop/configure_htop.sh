#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash

configure_htop(){
	cd ${BASEDIR}
	
	echo "Configuring htop ..."
	if [ -f ~/.htoprc ]; then
		backup_file rename ~/.htoprc
	fi
	cp htoprc ~/.htoprc
	
	echo
}



cd ${BASEDIR}
configure_htop 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
