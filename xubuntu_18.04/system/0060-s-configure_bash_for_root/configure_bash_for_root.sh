#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

configure_bash_for_root(){
	cd ${BASEDIR}
	
	echo "Configuring bash for root ..."
	backup_file rename /root/.bashrc
	cp ./bashrc /root/.bashrc
	
	echo
}

cd ${BASEDIR}

configure_bash_for_root 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
