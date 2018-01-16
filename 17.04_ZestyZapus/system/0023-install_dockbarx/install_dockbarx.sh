#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_dockbarx(){
	cd ${BASEDIR}
	
	echo 'Installing DockbarX from ppa:dockbar-main/ppa ...'
	add-apt-repository -y ppa:dockbar-main/ppa
	apt-get update
	apt-get install -y dockbarx dockbarx-themes-extra
}

cd ${BASEDIR}
install_dockbarx 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
