#!/usr/bin/env bash

source ../../../../felix.sh
source ../../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

install_wifi(){
	cd ${BASEDIR}
	
	echo "Installing Wi-Fi ..."
	apt-get install -y bcmwl-kernel-source
	
	echo
}

cd ${BASEDIR}

install_wifi 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
