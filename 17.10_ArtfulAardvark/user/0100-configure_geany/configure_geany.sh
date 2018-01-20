#!/bin/bash

source ../../common.sh
check_shell

configure_geany(){
	cd ${BASEDIR}
	
	echo 'Configuring geany ...'
	if [[ -f ~/.config/geany ]]; then
		backup_file rename ~/.config/geany
	fi
	if [ ! -f ~/.config/geany ]; then
		mkdir -p ~/.config/geany/filedefs
	fi
	cp ./filetypes.common ~/.config/geany/filedefs/filetypes.common
	
	# Force geany to open files in new instance
	if [ ! -f ~/.local/share/applications ]; then
		mkdir -p ~/.local/share/applications
	fi
	cp ./geany.desktop ~/.local/share/applications/geany.desktop
}

cd ${BASEDIR}
configure_geany 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
