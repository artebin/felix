#!/bin/bash

source ../../common.sh
check_shell

configure_geany(){
	cd ${BASEDIR}
	
	echo "Configuring geany ..."
	
	# Backup pre-existing geany config directory if it exists
	if [ -d ~/.config/geany ]; then
		backup_file rename ~/.config/geany
	fi
	mkdir -p ~/.config/geany
	
	# Geany keybindings
	cp ./geany_1.29.keybindings.conf ~/.config/geany/keybindings.conf
	
	# Geany filedefs
	mkdir -p ~/.config/geany/filedefs
	cp ./geany_1.29.filetypes.common ~/.config/geany/filedefs/filetypes.common
	
	# GitHub markdown CSS
	mkdir -p ~/.config/geany/plugins/markdown
	cp ./github-markdown.css ~/.config/geany/plugins/markdown
	cp ./github-markdown.html ~/.config/geany/plugins/markdown
	
	# Force geany to open files in new instance
	if [ ! -d ~/.local/share/applications ]; then
		mkdir -p ~/.local/share/applications
	fi
	cp ./geany.desktop ~/.local/share/applications/geany.desktop
}

cd ${BASEDIR}
configure_geany 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
