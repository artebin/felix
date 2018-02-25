#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_dockbarx(){
	cd ${BASEDIR}
	
	echo "Installing DockbarX from ppa:dockbar-main/ppa ..."
	
	# Xubuntu 17.04 should use:
	add-apt-repository -y ppa:dockbar-main/ppa
	
	# Xubuntu 17.10 should use:
	#add-apt-repository -y ppa:xuzhen666/dockbarx
	
	apt-get update
	apt-get install -y dockbarx dockbarx-themes-extra
}

cd ${BASEDIR}
install_dockbarx 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
