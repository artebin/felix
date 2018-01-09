#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

upgrade_system(){
	cd ${BASEDIR}
	
	echo "Upgrading the system ..."
	apt-get update
	apt-get -y upgrade
	apt-get -y dist-upgrade
}

cd ${BASEDIR}
upgrade_system 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
