#!/usr/bin/env bash

source ../../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

fix_backlight_after_suspend(){
	cd ${BASEDIR}
	
	echo "Fixing backlight after suspend ..."
	
	cd ${BASEDIR}
	git clone git://github.com/patjak/mba6x_bl
	cd ./mba6x_bl
	make
	make install
	depmod -a
	modprobe mba6x_bl
	
	cd ${BASEDIR}
	cp ./98-mba6bl.conf /usr/share/X11/xorg.conf.d/98-mba6bl.conf
	if [ -f "/usr/share/X11/xorg.conf.d/20-intel.conf" ]; then
		backup_file rename /usr/share/X11/xorg.conf.d/20-intel.conf
	fi
	
	# Cleaning
	cd ${BASEDIR}
	rm -rf ./mba6x_bl
	
	echo
}

cd ${BASEDIR}

fix_backlight_after_suspend 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
