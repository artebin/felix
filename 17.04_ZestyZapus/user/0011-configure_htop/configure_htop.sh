#!/bin/bash

source ../../common.sh
check_shell

configure_htop(){
	cd ${BASEDIR}
	
	echo "Configuring htop ..."
	if [ -f ~/.htoprc ]; then
		backup_file rename ~/.htoprc
	fi
	cp htoprc ~/.htoprc
}

cd ${BASEDIR}
configure_htop 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
