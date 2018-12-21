#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell

configure_bash(){
	cd ${BASEDIR}
	
	echo "Configuring bash ..."
	if [ -f ~/.bashrc ]; then
		backup_file rename ~/.bashrc
	fi
	cp ./bashrc ~/.bashrc
	
	echo
}

cd ${BASEDIR}

configure_bash 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
