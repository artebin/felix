#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME="openbox_badge-symbolic#1.svg"

add_lightdm_greeter_badges(){
	cd ${BASEDIR}
	
	echo "Adding lightdm greeter badges ..."
	cp ./${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
	update-icon-caches /usr/share/icons/hicolor
	
	echo
}

cd ${BASEDIR}

add_lightdm_greeter_badges 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
