#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_dex_from_sources(){
	echo "Installing dex from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "python3-sphinx"
	
	# Clone git repository
	cd ${RECIPE_DIR}
	git clone https://github.com/jceb/dex
	
	# Patch dex for supporting 'Terminal=(true|false)' property in .desktop files
	# See <https://github.com/jceb/dex/issues/33>
	cd dex
	patch dex < ../fix_terminal_property.patch
	
	# Install
	make install
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr dex
	
	echo
}



cd ${RECIPE_DIR}
install_dex_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
