#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
	echo "This script should run with bash" 1>&2
	exit 1
fi

source ./common.sh

readarray -t SYSTEM_SCRIPT_PATH_ARRAY < <(find ./system/ -regex ".*/[0-9][0-9][0-9][0-9].*\\.sh"|sort)

execute_all_system_scripts(){
	for SCRIPT_PATH in "${SYSTEM_SCRIPT_PATH_ARRAY[@]}"; do
		cd "${BASEDIR}"
		
		echo
		
		SCRIPT_NAME=$(basename "${SCRIPT_PATH}")
		echo "SCRIPT_NAME=${SCRIPT_NAME}"
		
		SCRIPT_PATH=$(readlink -f "${SCRIPT_PATH}")
		echo "SCRIPT_PATH=${SCRIPT_PATH}"
		
		SCRIPT_BASE_DIRECTORY=$(dirname "${SCRIPT_PATH}")
		echo "SCRIPT_BASE_DIRECTORY=${SCRIPT_BASE_DIRECTORY}"
		
		SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
		echo "SCRIPT_LOG_NAME=${SCRIPT_LOG_NAME}"
		
		cd "${SCRIPT_BASE_DIRECTORY}"
		#sudo bash "./${SCRIPT_NAME}"
		
		echo
	done
}

check_xubuntu_version && execute_all_system_scripts
