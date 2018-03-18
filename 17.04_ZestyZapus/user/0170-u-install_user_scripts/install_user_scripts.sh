#!/bin/bash

source ../../common.sh
check_shell

install_user_scripts(){
	cd ${BASEDIR}
	
	echo "Installing user scripts ..."
	
	if [ ! -d ~/scripts ]; then
		mkdir ~/scripts
	fi
	
	for FILE in ./scripts/*; do
		FILENAME=$(basename ${FILE})
		if [ -e ~/scripts/"${FILENAME}" ]; then
			echo "~/scripts/${FILENAME} already exists => skipping it!"
			continue
		fi
		cp -r ./scripts/"${FILENAME}" ~/scripts/"${FILENAME}"
	done
}

cd ${BASEDIR}
install_user_scripts 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
