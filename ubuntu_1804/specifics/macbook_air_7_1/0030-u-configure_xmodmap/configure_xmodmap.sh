#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_xmodmap(){
	echo "Configuring xmodmap ..."
	
	if [[ -f "${HOME}/.Xmodmap" ]]; then
		backup_file rename "${HOME}/.Xmodmap"
	fi
	
	cd "${RECIPE_DIR}"
	cp Xmodmap "${HOME}/.Xmodmap"
	echo "xmodmap ${HOME}/.Xmodmap" >> ~/.xinitrc
	
	echo
}

configure_xmodmap 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
