#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pulseaudioctl_from_sources(){
	echo "Installing pulseaudio-ctl from sources ..."
	
	# Clone git repository
	git clone https://github.com/graysky2/pulseaudio-ctl
	
	# Build and install
	cd pulseaudio-ctl
	make
	make install
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr pulseaudio-ctl
	
	echo
}



cd ${RECIPE_DIR}
install_pulseaudioctl_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
