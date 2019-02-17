#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash
exit_if_has_not_root_privileges

upgrade_system(){
	echo "Upgrading the system ..."
	
	apt-get update
	apt-get -y upgrade
	apt-get -y dist-upgrade
	
	echo
}

cd "${BASEDIR}"
upgrade_system 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
