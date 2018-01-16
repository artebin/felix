#!/bin/bash

source '../../common.sh'
check_shell
exit_if_has_not_root_privileges

install_sqlitebrowser(){
	cd "${BASEDIR}"
	
	echo 'Installing sqlitebrowser from ppa:linuxgndu/sqlitebrowser ...'
	add-apt-repository -y 'ppa:linuxgndu/sqlitebrowser'
	apt-get update
	apt-get install -y sqlitebrowser
}

cd "${BASEDIR}"
install_sqlitebrowser 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
