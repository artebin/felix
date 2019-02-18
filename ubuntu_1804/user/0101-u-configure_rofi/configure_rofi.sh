#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf


LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE})"

exit_if_not_bash

configure_rofi(){
	echo "Configure rofi ..."
	
	cd "${BASEDIR}"
	if [[ -f ~/.config/rofi ]]; then
		backup_file rename ~/.config/rofi
	fi
	if [[ ! -f ~/.config/rofi ]]; then
		mkdir -p ~/.config/rofi
	fi
	cp ./rofi_1.5.0_config ~/.config/rofi/config
	
	echo
}


cd "${BASEDIR}"
configure_rofi 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
