#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_ssh_welcome_text(){
	cd ${BASEDIR}
	
	echo "Setting SSH welcome text ..."
	
	# Disabling all previous "message of the day"
	cd /etc/update-motd.d
	for FILE in ./*; do
		backup_file rename ./"${FILE}"
	done
	
	# Adding Tux Welcome Dude
	cd ${BASEDIR}
	cp ./00-welcome-dude /etc/update-motd.d/00-welcome-dude
	cp ./tux /etc/update-motd.d/tux
	cd /etc/update-motd.d
	chmod 755 00-welcome-dude
	chmod 644 tux
	chmod a-x 00-header
	chmod a-x 10-help-text
}

cd ${BASEDIR}
configure_ssh_welcome_text 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
