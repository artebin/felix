#!/bin/bash

source ../../common.sh
check_shell

configure_vim(){
	cd ${BASEDIR}
	
	echo "Configuring vim ..."
	renameFileForBackup ~/.vimrc
	cp ./vimrc ~/.vimrc
}

configure_vim 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
