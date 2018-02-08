#!/bin/bash

source ../../../common.sh
check_shell
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
	
	cp ./98-mba6bl.conf /usr/share/X11/xorg.conf.d/98-mba6bl.conf
	if [ -f "/usr/share/X11/xorg.conf.d/20-intel.conf" ]; then
		backup_file rename /usr/share/X11/xorg.conf.d/20-intel.conf
	fi
}

cd ${BASEDIR}
fix_backlight_after_suspend 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
