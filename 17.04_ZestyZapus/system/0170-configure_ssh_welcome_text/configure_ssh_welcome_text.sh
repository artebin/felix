#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_ssh_welcome_text(){
	cd ${BASEDIR}
	
	echo "Setting SSH welcome text ..."
	cp ./00-welcome-dude /etc/update-motd.d/00-welcome-dude
	cp ./tux /etc/update-motd.d/tux
	cd /etc/update-motd.d
	chmod 755 00-welcome-dude
	chmod 644 tux
	chmod a-x 00-header
	chmod a-x 10-help-text
}

cd ${BASEDIR}
configure_ssh_welcome_text 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
