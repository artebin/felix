#!/usr/bin/env bash

source ../../felix.sh

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_virtualbox_guest_additions(){
	
	DEPENDENCIES=(  "virtualbox-guest-dkms-hwe"
					"virtualbox-guest-utils-hwe"
					"virtualbox-guest-x11-hwe" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	echo
}

cd "${BASEDIR}"
install_virtualbox_guest_additions 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
