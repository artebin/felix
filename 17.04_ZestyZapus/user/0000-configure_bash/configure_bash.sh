#!/bin/bash

source ../../common.sh
check_shell

configure_bash(){
	cd ${BASEDIR}
	
	echo "Configuring bash ..."
	if [ -f ~/.bashrc ]; then
		backup_file rename ~/.bashrc
	fi
	cp ./bashrc ~/.bashrc
}

cd ${BASEDIR}
configure_bash 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
