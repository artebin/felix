#!/bin/bash

source ../../../common.sh
check_shell

configure_xmodmap(){
	cd ${BASEDIR}
	
	echo "Configuring xmodmap ..."
	if [ -f "~/.xmodmap" ]; then
		backup_file rename ~/.xmodmap
	fi
	
	cp ./Xmodmap ~/.Xmodmap
	echo "xmodmap ~/.Xmodmap" >> ~/.xinitrc
}

cd ${BASEDIR}
configure_xmodmap 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
