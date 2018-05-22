#!/usr/bin/bash

source ../../../common.sh
check_shell
exit_if_has_not_root_privileges

disable_touchscreen(){
	cd ${BASEDIR}
	
	# For disabling the touchscreen we can use use:
	#  - `xinput` and `xinput disable <device ID>`, it can be done when we login via the `.xsession`
	#  - disable it directly in the X.org configuration in `/usr/share/X11/xorg.conf/40-libinput.conf`
	# Here we disable it in X.org configuration
	
	echo "Disabling touchscreen ..."
	sudo sed -i.bak "s/MatchIsTouchscreen \"on\"/MatchIsTouchscreen \"off\"/g" /usr/share/X11/xorg.conf/40-libinput.conf
}

cd ${BASEDIR}
disable_touchscreen 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
