#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
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

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_ssh_welcome_text 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
