#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_geany(){
	cd ${RECIPE_DIR}
	
	echo "Configuring Geany ..."
	
	# Backup pre-existing Geany config directory if it exists
	if [ -d ~/.config/geany ]; then
		backup_file rename ~/.config/geany
	fi
	mkdir -p ~/.config/geany
	
	# Geany conf
	cp ./geany_1.29.geany.conf ~/.config/geany/geany.conf
	
	# Geany keybindings
	cp ./geany_1.29.keybindings.conf ~/.config/geany/keybindings.conf
	
	# Geany filedefs
	mkdir -p ~/.config/geany/filedefs
	cp ./geany_1.29.filetypes.common ~/.config/geany/filedefs/filetypes.common
	
	# GitHub markdown CSS
	mkdir -p ~/.config/geany/plugins/markdown
	cp ./github-markdown.html ~/.config/geany/plugins/markdown
	
	# Force Geany to re-use the same instance per desktop/workspace
	# I can not make it work by overriding geany.desktop in ~/.local/share/applications
	# I directly fix the /usr/share/applications/geany.desktop file
	sudo cp ./geany_one_instance_per_workspace.sh /usr/bin/geany_one_instance_per_workspace
	sudo chmod a+x /usr/bin/geany_one_instance_per_workspace
	sudo sed -i "s/Exec=.*/Exec=bash geany_one_instance_per_workspace %F/" /usr/share/applications/geany.desktop
	sudo update-desktop-database
	
	echo
}



cd ${RECIPE_DIR}
configure_geany 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
