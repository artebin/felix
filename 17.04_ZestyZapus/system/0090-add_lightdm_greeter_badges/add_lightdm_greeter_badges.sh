#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME="openbox_badge-symbolic#1.svg"

add_lightdm_greeter_badges(){
	cd ${BASEDIR}
	
	echo "Adding lightdm greeter badges ..."
	cp ./${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
	update-icon-caches /usr/share/icons/hicolor
}

cd ${BASEDIR}
add_lightdm_greeter_badges 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
