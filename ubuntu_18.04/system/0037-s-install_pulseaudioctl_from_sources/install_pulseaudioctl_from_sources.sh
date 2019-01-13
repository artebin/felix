#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
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
	cd ${BASEDIR}
	rm -fr pulseaudio-ctl
	
	echo
}

cd ${BASEDIR}
install_pulseaudioctl_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
