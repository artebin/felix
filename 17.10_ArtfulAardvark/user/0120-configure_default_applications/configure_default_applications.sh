#!/bin/bash

source ../../common.sh
check_shell

configure_default_applications(){
	cd ${BASEDIR}
	
	# Note: the .desktop can be found in /usr/share/applications
	
	echo 'Configuring mate-caja as default file browser ...'
	mkdir -p ~/.local/share/applications
	cp ./caja.desktop ~/.local/share/applications/caja.desktop
	xdg-mime default caja.desktop inode/directory
	
	echo 'Configuring thunderbird as default mail client ...'
	xdg-mime default thunderbird.desktop x-scheme-handler/mailto
}

cd ${BASEDIR}
configure_default_applications 2>&1 | tee -a ./${SCRIPT_LOG_NAME}