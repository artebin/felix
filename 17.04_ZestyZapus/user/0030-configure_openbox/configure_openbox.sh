#!/bin/bash

source ../../common.sh
check_shell

configure_openbox(){
	cd ${BASEDIR}
	
	echo "Configuring openbox ..."
	renameFileForBackup ~/.config/openbox
	if [ ! -f ~/.config/openbox ]; then
		mkdir -p ~/.config/openbox
	fi
	cp ./autostart ~/.config/openbox
	cp ./dialog_command.sh ~/.config/openbox
	cp ./menu.xml ~/.config/openbox
	cp ./obapps-0.1.7.tar.gz ~/.config/openbox
	cp ./rc.xml ~/.config/openbox
}

cd ${BASEDIR}
configure_openbox 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
