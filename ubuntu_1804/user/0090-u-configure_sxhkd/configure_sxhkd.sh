#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_sxhkd(){
	echo "Configuring sxhkd ..."
	
	if [[ -d ~/.config/sxhkd ]]; then
		backup_file rename ~/.config/sxhkd
	fi
	
	cd "${BASEDIR}"
	mkdir -p ~/.config/sxhkd
	cp sxhkdrc ~/.config/sxhkd/sxhkdrc
	
	echo
}

cd "${BASEDIR}"
configure_sxhkd 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
