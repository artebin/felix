#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_xfce4_thunar(){
	cd ${BASEDIR}
	
	echo "Configuring xfce4-thunar ..."
	CONFIG_FILE="thunar.xml"
	if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}" ]; then
		backup_file rename ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}"
	fi
	mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
	cp "${CONFIG_FILE}" ~/.config/xfce4/xfconf/xfce-perchannel-xml
	
	echo
}



cd ${BASEDIR}
configure_xfce4_thunar 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
