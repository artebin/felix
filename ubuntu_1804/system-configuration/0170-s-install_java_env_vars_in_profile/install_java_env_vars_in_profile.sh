#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_java_env_vars(){
	cd ${BASEDIR}
	
	echo "Installing Java environment variables ..."
	cp ./java_env_vars.sh /etc/profile.d/java_env_vars.sh
	
	echo
}



cd ${BASEDIR}
install_java_env_vars 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
