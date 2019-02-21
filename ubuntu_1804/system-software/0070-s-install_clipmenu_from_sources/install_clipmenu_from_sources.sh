#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_clipmenu_from_sources(){
	cd ${RECIPE_DIR}
	
	# ClipNotify
	cd ${RECIPE_DIR}
	echo "Installing ClipNotify from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipnotify>"
	git clone https://github.com/cdown/clipnotify
	cd ./clipnotify
	make
	cp ./clipnotify /usr/bin
	
	# ClipMenu
	cd ${RECIPE_DIR}
	echo "Installing ClipMenu from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipmenu>"
	git clone https://github.com/cdown/clipmenu
	cd ./clipmenu
	cp ./clipdel /usr/bin
	cp ./clipmenu /usr/bin
	cp ./clipmenud /usr/bin
	
	# I can not make it work with the service
	# It will be executed via openbox autostart
	#cp ./init/clipmenud.service /etc/systemd/system
	#systemctl daemon-reload
	#systemctl start clipmenud.service
	#systemctl status clipmenud.service
	#systemctl enable clipmenud.service
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr ./clipnotify
	rm -fr ./clipmenu
	
	echo
}



cd ${RECIPE_DIR}
install_clipmenu_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
