#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_xfce4_thunar(){
	cd ${BASEDIR}
	
	echo "Configuring xfce4-thunar ..."
	CONFIG_FILE="thunar.xml"
	if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}" ]; then
		backup_file rename ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}"
	fi
	mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
	cp "${CONFIG_FILE}" ~/.config/xfce4/xfconf/xfce-perchannel-xml
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_xfce4_thunar 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
