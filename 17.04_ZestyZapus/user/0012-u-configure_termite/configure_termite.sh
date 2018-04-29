#!/bin/bash

source ../../common.sh
check_shell

configure_termite(){
	cd ${BASEDIR}
	
	echo "Configuring Termite ..."
	if [ -d ~/.config/termite ]; then
		backup_file rename ~/.config/termite
	fi
	mkdir ~/.config/termite
	cp ./config ~/.config/termite/config
}

cd ${BASEDIR}
configure_termite 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
