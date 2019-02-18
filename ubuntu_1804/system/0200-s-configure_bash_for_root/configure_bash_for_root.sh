#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash
exit_if_has_not_root_privileges

configure_bash_for_root(){
	cd ${BASEDIR}
	
	echo "Configuring bash for root ..."
	backup_file rename /root/.bashrc
	cp ./bashrc /root/.bashrc
	
	echo
}



cd ${BASEDIR}
configure_bash_for_root 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
