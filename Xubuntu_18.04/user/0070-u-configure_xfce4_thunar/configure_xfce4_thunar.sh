#!/usr/bin/env bash

source ../../common.sh
check_shell

configure_xfce4_thunar(){
	cd ${BASEDIR}
	
	echo "Configuring xfce4-thunar ..."
	if [[ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml ]]; then
		backup_file rename ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
	fi
	if [ ! -f ~/.config/xfce4/xfconf/xfce-perchannel-xml ]; then
		mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
	fi
	cp ./thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
}

cd ${BASEDIR}
configure_xfce4_thunar 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
