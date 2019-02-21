#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_rofi(){
	echo "Configure rofi ..."
	
	cd "${RECIPE_DIR}"
	if [[ -d ~/.config/rofi ]]; then
		backup_file rename ~/.config/rofi
	fi
	mkdir -p ~/.config/rofi
	cp rofi_1.5.0_config ~/.config/rofi/config
	
	echo
}

cd "${RECIPE_DIR}"
configure_rofi 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
