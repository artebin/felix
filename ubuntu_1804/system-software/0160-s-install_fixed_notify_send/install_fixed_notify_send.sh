#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_fixed_notify_send(){
	echo "Install a fixed version of notify-send ..."
	
	# Remove package libnotidy-bin if installed
	remove_with_purge_package_if_installed "libnotify-bin"
	
	# Clone git repository
	cd ${BASEDIR}
	git clone https://github.com/vlevit/notify-send.sh
	
	# Install
	cd ${BASEDIR}
	cd notify-send.sh
	cp notify-send.sh /usr/bin/notify-send
	cp notify-action.sh /usr/bin/notify-action
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr notify-send.sh
	
	echo
}



cd ${BASEDIR}
install_fixed_notify_send 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
