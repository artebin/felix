#!/usr/bin/env bash

source ../../../../felix.sh
source ../../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_apple_hid(){
	cd ${BASEDIR}
	
	echo "Configuring Apple HID (use fn key for special functions keys) ..."
	echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf
	update-initramfs -u -k all
	
	echo
}


cd ${BASEDIR}
configure_apple_hid 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
