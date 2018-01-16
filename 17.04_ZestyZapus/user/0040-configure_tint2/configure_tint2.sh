#!/bin/bash

source ../../common.sh
check_shell

configure_tint2(){
	cd "${BASEDIR}"
	
	echo 'Configuring tint2 ...'
	backup_file rename '~/.config/tint2'
	if [ ! -f '~/.config/tint2' ]; then
		mkdir -p '~/.config/tint2'
	fi
	cp './tint2rc' '~/.config/tint2/tint2rc'
}

cd "${BASEDIR}"
configure_tint2 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
