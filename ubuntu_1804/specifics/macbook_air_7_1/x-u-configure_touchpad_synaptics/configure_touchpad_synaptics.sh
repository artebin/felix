#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_touchpad_synaptics(){
	cd ${BASEDIR}
	
	echo "Configuring touchpad synaptics ..."
	
	echo "Setting sensitivity ..."
	echo "\nsynclient FingerLow=110 FingerHigh=120 &\n"  >> ~/.config/openbox/autostart
	
	echo
}


cd ${BASEDIR}
configure_touchpad_synaptics 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
