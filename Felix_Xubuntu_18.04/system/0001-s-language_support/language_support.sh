#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell
exit_if_has_not_root_privileges

process_package_install_list(){
	cd ${BASEDIR}
	
	echo "Installing missing language support ..."
	xargs apt-get -y install < ./packages.install.list
	
	echo
}

cd ${BASEDIR}

process_package_install_list 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
