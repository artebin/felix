#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

disable_usb_lid_wakeup(){
	cd ${BASEDIR}
	
	echo "Disabling wakeup on USB or lid ..."
	if [ -f /etc/systemd/system/no_usb_lid_wakeup.service ]; then
		echo "/etc/systemd/system/no_usb_lid_wakeup.service already exists"
		exit 1
	else
		cp ./no_usb_lid_wakeup.service /etc/systemd/system/no_usb_lid_wakeup.service
		systemctl daemon-reload
		systemctl start no_usb_lid_wakeup.service
		systemctl status no_usb_lid_wakeup.service
		systemctl enable no_usb_lid_wakeup.service
	fi
}

cd ${BASEDIR}
disable_usb_lid_wakeup 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
