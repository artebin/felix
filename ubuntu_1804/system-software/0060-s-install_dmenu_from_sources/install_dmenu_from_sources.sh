#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_dmenu_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing dmenu from sources ..."
	tar xzf dmenu-4.7.tar.gz
	cp ./dmenu-lineheight-4.7.diff ./dmenu-4.7/
	cp ./dmenu-xyw-4.7.diff ./dmenu-4.7/
	
	cd ./dmenu-4.7
	patch < dmenu-lineheight-4.7.diff
	patch < dmenu-xyw-4.7.diff
	make
	make install
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr ./dmenu-4.7/
	
	echo
}



cd ${BASEDIR}
install_dmenu_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
