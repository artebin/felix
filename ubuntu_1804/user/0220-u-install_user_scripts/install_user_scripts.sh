#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

install_user_scripts(){
	echo "Install user scripts ..."
	
	cd "${BASEDIR}"
	if [[ -d ~/scripts ]]; then
		backup_file rename ~/scripts
	fi
	cp scripts ~/scripts
	
	echo
}

cd "${BASEDIR}"
install_user_scripts 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
