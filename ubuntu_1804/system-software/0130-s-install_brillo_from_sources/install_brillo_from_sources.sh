#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_brillo_from_sources(){
	echo "Install brillo from sources ..."
	
	# See <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.
	
	# Install dependencies
	install_package_if_not_installed "go-md2man"
	
	# Clone repository
	cd ${BASEDIR}
	git clone https://gitlab.com/cameronnemo/brillo
	
	# Compile and install
	cd ${BASEDIR}
	cd brillo
	make
	make install
	make dist
	make install-dist
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr brillo
	
	echo
}



cd ${BASEDIR}
install_brillo_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
