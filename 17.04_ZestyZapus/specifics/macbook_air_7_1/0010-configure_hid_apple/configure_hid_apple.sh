#!/bin/bash

source ../../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_apple_hid(){
	cd ${BASEDIR}
	
	echo "Configuring Apple HID (use fn key for special functions keys) ..."
	echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf
	update-initramfs -u -k all
}

cd ${BASEDIR}
configure_apple_hid 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
