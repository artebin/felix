#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
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
fix_backlight_after_suspend 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
