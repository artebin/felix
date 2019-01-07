#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_mps_youtube_from_sources(){
	echo "Install mps-youtube from sources ..."
	
	# Install dependencies
	if ! $(is_package_installed "python3-pip"); then
		apt-get install -y "python3-pip"
	fi
	
	# Install youtube-dl from sources
	cd ${BASEDIR}
	git clone http://github.com/rg3/youtube-dl
	cd youtube-dl
	make
	make install
	python3 setup.py install
	
	# Install mps-youtube and other dependencies
	pip3 install dbus-python pygobject
	pip3 install colorama
	pip3 install mps-youtube
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr youtube-dl
	
	echo
}

cd ${BASEDIR}
install_mps_youtube_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi