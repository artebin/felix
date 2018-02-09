#!/bin/bash

source ../../common.sh
check_shell

configure_mate_terminal(){
	cd ${BASEDIR}
	
	echo "Configuring mate-terminal ..."
	dconf load /org/mate/terminal/ < ./org.mate.terminal.dump
}

cd ${BASEDIR}
configure_mate_terminal 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
