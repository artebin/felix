#!/usr/bin/env bash

source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

install_dex_from_sources(){
	echo "Installing dex from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "python3-sphinx"
	
	# Clone git repository
	cd ${BASEDIR}
	git clone https://github.com/jceb/dex
	
	# Patch dex for supporting 'Terminal=(true|false)' property in .desktop files
	# See <https://github.com/jceb/dex/issues/33>
	cd dex
	patch dex < ../fix_terminal_property.patch
	
	# Install
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr dex
	
	echo
}

cd ${BASEDIR}
install_dex_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
