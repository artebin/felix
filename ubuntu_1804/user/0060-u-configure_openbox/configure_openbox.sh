#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_openbox(){
	echo "Configuring openbox ..."
	
	if [[ -d ~/.config/openbox ]]; then
		backup_file rename ~/.config/openbox
	fi
	mkdir -p ~/.config/openbox
	
	cd "${RECIPE_DIR}"
	cp autostart ~/.config/openbox
	cp rc.xml ~/.config/openbox
	cp menu.xml ~/.config/openbox
	cp obapps-0.1.7.tar.gz ~/.config/openbox
	
	echo
}

cd "${RECIPE_DIR}"
configure_openbox 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
