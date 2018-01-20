#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

process_package_remove_list(){
	cd ${BASEDIR}
	
	echo 'Remove unwanted packages ...'
	xargs apt-get -y --purge remove < ./packages.remove.list
	apt-get -y autoremove
}

cd ${BASEDIR}
process_package_remove_list 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
