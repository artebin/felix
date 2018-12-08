#!/usr/bin/env bash

source ../../common.sh
check_shell

install_java_env_vars(){
	cd ${BASEDIR}
	
	echo "Installing Java environment variables in ~/.xsessionrc ..."
	cat java_env_vars.xsessionrc >> ~/.xsessionrc
}

cd ${BASEDIR}
install_java_env_vars 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
