#!/bin/bash

source ../../common.sh
check_shell

configure_geany(){
	cd ${BASEDIR}
	
	echo 'Configuring geany ...'
	
	# Backup pre-existing geany config directory if it exists
	if [[ -f ~/.config/geany ]]; then
		backup_file rename ~/.config/geany
	fi
	
	# Create geany config directory if it does not exist
	if [ ! -f ~/.config/geany ]; then
		mkdir -p ~/.config/geany/filedefs
	fi
	
	# Geany keyboard shortcuts:
	# menu_messagewindow	= F6
	# toggle_sidebar		= F7
	# build_link			= <Shift>F8
	# build_make			= <Primary><Shift>F8
	# build_run				= F9
	# switch_search_bar		= F3
	# switch_scribble		= F5
	cp ./geany_1.29.keybindings.conf ~/.config/geany/keybindings.conf
	
	# Geany configuration
	cp ./geany_1.29.filetypes.common ~/.config/geany/filedefs/filetypes.common
	
	# Force geany to open files in new instance
	if [ ! -f ~/.local/share/applications ]; then
		mkdir -p ~/.local/share/applications
	fi
	cp ./geany.desktop ~/.local/share/applications/geany.desktop
}

cd ${BASEDIR}
configure_geany 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
