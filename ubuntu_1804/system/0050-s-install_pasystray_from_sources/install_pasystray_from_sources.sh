#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash
exit_if_has_not_root_privileges

install_pasystray(){
	cd ${BASEDIR}
	
	echo "Cloning pasystray from http://github.com/christophgysin/pasystray ..."
	git clone http://github.com/christophgysin/pasystray
	
	echo "Compiling pasystray ..."
	cd pasystray
	./bootstrap.sh
	./configure
	make
	
	echo "Installing pasystray ..."
	make install
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr pasystray
}



cd ${BASEDIR}
install_pasystray 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
