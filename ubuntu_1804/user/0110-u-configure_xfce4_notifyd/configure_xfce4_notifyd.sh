#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_xfce4_notifyd(){
	cd ${BASEDIR}
	
	# 
	# Xfce stores its config in ~/.config/xfce4/xfconf/xfce-perchannel-xml/
	# These files should not be changed while logged in xfce (they will be overwritten).
	# Should use xfconf-query applying changes during xfce runtime.
	#
	# We can use xfce4-settings-editor to explore the database.
	#
	
	echo "Configuring xfce4-notifyd ..."
	CONFIG_FILE="xfce4-notifyd.xml"
	if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}" ]; then
		backup_file rename ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}"
	fi
	mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
	cp "${CONFIG_FILE}" ~/.config/xfce4/xfconf/xfce-perchannel-xml
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_xfce4_notifyd 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
