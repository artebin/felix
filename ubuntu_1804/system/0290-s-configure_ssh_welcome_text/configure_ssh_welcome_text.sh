#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_ssh_welcome_text(){
	cd ${BASEDIR}
	
	echo "Setting SSH welcome text ..."
	
	# Disabling all previous "message of the day"
	cd /etc/update-motd.d
	for FILE in ./*; do
		backup_file rename ./"${FILE}"
	done
	chmod a-x ./*
	
	# Adding Tux Welcome Dude
	cd ${BASEDIR}
	cp ./00-welcome-dude /etc/update-motd.d/00-welcome-dude
	cp ./tux /etc/update-motd.d/tux
	cd /etc/update-motd.d
	chmod 744 00-welcome-dude
	chmod 644 tux
	
	echo
}



cd ${BASEDIR}
configure_ssh_welcome_text 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
