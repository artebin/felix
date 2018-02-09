#!/bin/bash

source ../../../common.sh
check_shell

configure_xmodmap(){
	cd ${BASEDIR}
	
	echo "Configuring xmodmap ..."
	if [ -f "~/.xmodmap" ]; then
		backup_file rename ~/.xmodmap
	fi
	cp ./xmodmap ~/.xmodmap
}

cd ${BASEDIR}
configure_xmodmap 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
