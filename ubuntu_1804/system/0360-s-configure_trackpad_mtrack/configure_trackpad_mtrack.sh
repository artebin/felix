#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash
exit_if_has_not_root_privileges

configure_trackpad_mtrack(){
	echo "Configuring trackpad mtrack ..."
	
	apt-get install -y xserver-xorg-input-mtrack
	
	# For reference, the X11 mouse button numbering:
	#   1 = left button
	#   2 = middle button (pressing the scroll wheel)
	#   3 = right button
	#   4 = turn scroll wheel up
	#   5 = turn scroll wheel down
	#   6 = push scroll wheel left
	#   7 = push scroll wheel right
	#   8 = 4th button (aka browser backward button)
	#   9 = 5th button (aka browser forward button)
	#
	# See <http://xahlee.info/linux/linux_x11_mouse_button_number.html>.
	
	cd ${BASEDIR}
	cp ./80-mtrack.conf /usr/share/X11/xorg.conf.d/
	
	echo
}



cd ${BASEDIR}
configure_trackpad_mtrack 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
