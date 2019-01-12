#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash

configure_vim(){
	cd ${BASEDIR}
	
	echo "Configuring vim ..."
	if [ -f ~/.vimrc ]; then
		backup_file rename ~/.vimrc
	fi
	cp ./vimrc ~/.vimrc
	
	echo
}

cd ${BASEDIR}

configure_vim 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
