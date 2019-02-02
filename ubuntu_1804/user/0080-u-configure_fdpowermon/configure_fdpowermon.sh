#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_fdpowermon(){
	echo "Configuring fdpowermon ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/fdpowermon
	cp faenza_felix.theme.cfg ~/.config/fdpowermon/theme.cfg
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_fdpowermon 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
