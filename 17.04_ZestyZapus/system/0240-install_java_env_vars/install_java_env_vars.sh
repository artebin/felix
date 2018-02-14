#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_java_env_vars(){
	cd ${BASEDIR}
	
	echo "Installing Java environment variables ..."
	cp ./java_env_vars.sh /etc/profile.d/java_env_vars.sh
}

cd ${BASEDIR}
install_java_env_vars 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
