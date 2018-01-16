#!/bin/bash

source ../../common.sh
check_shell

configure_htop(){
	cd "${BASEDIR}"
	
	echo 'Configuring htop ...'
	backup_file rename '~/.htoprc'
	cp htoprc '~/.htoprc'
}

cd "${BASEDIR}"
configure_htop 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
