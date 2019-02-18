#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

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
configure_vim 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
