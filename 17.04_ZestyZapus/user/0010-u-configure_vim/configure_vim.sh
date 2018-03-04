#!/bin/bash

source ../../common.sh
check_shell

configure_vim(){
	cd ${BASEDIR}
	
	echo "Configuring vim ..."
	if [ -f ~/.vimrc ]; then
		backup_file rename ~/.vimrc
	fi
	cp ./vimrc ~/.vimrc
}

cd ${BASEDIR}
configure_vim 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
