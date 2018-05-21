#!/bin/bash

source ../../common.sh
check_shell

configure_tint2(){
	cd ${BASEDIR}
	
	echo "Configuring tint2 ..."
	if [ -f ~/.config/tint2 ]; then
		backup_file rename ~/.config/tint2
	fi
	if [ ! -f ~/.config/tint2 ]; then
		mkdir -p ~/.config/tint2
	fi
	cp ./tint2rc ~/.config/tint2/tint2rc
}

cd ${BASEDIR}
configure_tint2 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
