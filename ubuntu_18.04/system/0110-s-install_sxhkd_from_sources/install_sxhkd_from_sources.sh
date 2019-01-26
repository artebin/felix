#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
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
	cd ${BASEDIR}
	rm -fr sxhkd
	
	echo
}

cd ${BASEDIR}
install_sxhkd_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
