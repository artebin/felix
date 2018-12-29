#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

fix_notify_send(){
	echo "Fix notify-send ..."
	
	if $(is_package_installed "libnotify-bin"); then
		apt-get remove -y "libnotify-bin"
	fi
	
	cd ${BASEDIR}
	git clone https://github.com/vlevit/notify-send.sh
	cd notify-send.sh
	cp notify-send.sh /usr/bin/notify-send
	cp notify-action.sh /usr/bin/notify-action
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr notify-send.sh
	
	echo
}

cd ${BASEDIR}

fix_notify_send 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
