#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_sxhkd_from_sources(){
	echo "Installing sxhkd from sources ..."
	
	# Install dependencies
	if ! $(is_package_installed "libxcb-util-dev"); then
		apt-get install -y "libxcb-util-dev"
	fi
	if ! $(is_package_installed "libxcb-keysyms1-dev"); then
		apt-get install -y "libxcb-keysyms1-dev"
	fi
	
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
