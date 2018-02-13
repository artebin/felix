#!/bin/bash

source ../../common.sh
check_shell

configure_dmenu(){
	cd ${BASEDIR}
	
	echo "Configuring dmenu ..."
	if [ -f ~/.config/dmenu ]; then
		backup_file rename ~/.config/dmenu
	fi
	if [ ! -f ~/.config/dmenu ]; then
		mkdir -p ~/.config/dmenu
	fi
	cp ./dmenu-bind.sh ~/.config/dmenu
	chmod +x ~/.config/dmenu/dmenu-bind.sh
}

cd ${BASEDIR}
configure_dmenu 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
