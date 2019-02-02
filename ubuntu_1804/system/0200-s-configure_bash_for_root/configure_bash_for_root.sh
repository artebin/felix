#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_bash_for_root(){
	cd ${BASEDIR}
	
	echo "Configuring bash for root ..."
	backup_file rename /root/.bashrc
	cp ./bashrc /root/.bashrc
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_bash_for_root 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
