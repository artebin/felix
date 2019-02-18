#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash
exit_if_has_not_root_privileges

install_translate_notify(){
	cd ${BASEDIR}
	
	echo "Install Translate-Notify ..."
	cp ./translate-notify.sh /usr/bin/translate-notify
	chmod a+x /usr/bin/translate-notify
	
	echo
}



cd ${BASEDIR}
install_translate_notify 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
