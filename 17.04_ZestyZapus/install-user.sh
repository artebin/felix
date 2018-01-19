#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
	echo "This script should run with bash" 1>&2
	exit 1
fi

source './common.sh'

if has_root_privileges; then
	echo 'This script should not be started with the root privileges'
	exit 1
fi

readarray -t SCRIPT_DIRECTORY_PATH_ARRAY < <(find ./user/ -type d -regex ".*/[0-9][0-9][0-9][0-9]-.*"|sort)

execute_all_user_scripts(){
	for SCRIPT_DIRECTORY_PATH in "${SCRIPT_DIRECTORY_PATH_ARRAY[@]}"; do
		cd "${BASEDIR}"
		
		# The script name is derived from the directory name
		SCRIPT_FILE_NAME=$(basename "${SCRIPT_PATH}"|sed /s/^[0-9][0-9][0-9][0-9]-//).sh
		SCRIPT_FILE_PATH=$(readlink -f "${SCRIPT_PATH}")
		SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
		
		echo
		
		echo "SCRIPT_DIRECTORY_PATH=${SCRIPT_DIRECTORY_PATH}"
		echo "SCRIPT_FILE_NAME=${SCRIPT_FILE_NAME}"
		echo "SCRIPT_FILE_PATH=${SCRIPT_FILE_PATH}"
		echo "SCRIPT_LOG_NAME=${SCRIPT_LOG_NAME}"
		
		#cd "${SCRIPT_BASE_DIRECTORY}"
		#bash "./${SCRIPT_NAME}"
		
		echo
	done
}

check_xubuntu_version && execute_all_user_scripts
