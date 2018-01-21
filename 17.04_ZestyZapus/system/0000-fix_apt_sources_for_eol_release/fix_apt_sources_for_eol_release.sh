#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

fix_apt_sources_for_eol_release(){
	cd ${BASEDIR}
	
	echo 'Fixing apt sources for EOL release ...'
	backup_file copy /etc/apt/sources.list
	bash -c "cat sources.list | sed 's/be\.archive\.ubuntu\.com/old-releases\.ubuntu\.com/g' >sources.list"
	bash -c "cat sources.list | sed 's/security\.ubuntu\.com/old-releases\.ubuntu\.com/g' >sources.list"
	apt-get update
}

cd ${BASEDIR}
fix_apt_sources_for_eol_release 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
