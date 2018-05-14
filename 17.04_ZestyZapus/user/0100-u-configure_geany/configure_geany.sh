#!/bin/bash

source ../../common.sh
check_shell

configure_geany(){
	cd ${BASEDIR}
	
	echo "Configuring Geany ..."
	
	# Backup pre-existing Geany config directory if it exists
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
	cp ./github-markdown.html ~/.config/geany/plugins/markdown
	
	# Force Geany to re-use the same instance per desktop/workspace
	if [ ! -d ~/.local/share/applications ]; then
		mkdir -p ~/.local/share/applications
	fi
	cp ./geany.desktop ~/.local/share/applications/geany.desktop
	cp ./geany_one_instance_per_workspace.sh ~/.config/openbox
}

cd ${BASEDIR}
configure_geany 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
