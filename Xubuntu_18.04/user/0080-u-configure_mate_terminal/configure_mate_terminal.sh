#!/usr/bin/env bash

source ../../common.sh
check_shell

configure_mate_terminal(){
	cd ${BASEDIR}
	
	echo "Configuring mate-terminal ..."
	dconf load /org/mate/terminal/ < ./org.mate.terminal.dump
	
	echo
}

cd ${BASEDIR}

configure_mate_terminal 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi