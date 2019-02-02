#!/usr/bin/env bash

source ../../../../felix.sh
source ../../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_apple_hid(){
	cd ${BASEDIR}
	
	echo "Configuring Apple HID (use fn key for special functions keys) ..."
	echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf
	update-initramfs -u -k all
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_apple_hid 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
