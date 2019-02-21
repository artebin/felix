#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_sxhkd_from_sources(){
	echo "Installing sxhkd from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "libxcb-util-dev" "libxcb-keysyms1-dev"
	
	# Clone git repository
	git clone https://github.com/baskerville/sxhkd
	
	# Build and install
	cd sxhkd
	make
	make install
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr sxhkd
	
	echo
}



cd ${RECIPE_DIR}
install_sxhkd_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
