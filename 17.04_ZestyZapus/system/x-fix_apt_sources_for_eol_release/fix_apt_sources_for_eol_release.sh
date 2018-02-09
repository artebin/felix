#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

fix_apt_sources_for_eol_release(){
	cd ${BASEDIR}
	
	# See <https://help.ubuntu.com/community/EOLUpgrades>
	echo "Fixing apt sources for EOL release ..."
	backup_file copy /etc/apt/sources.list
	cp /etc/apt/sources.list ./sources.list
	sed -i "s/be\.archive\.ubuntu\.com/old-releases\.ubuntu\.com/g" ./sources.list
	sed -i "s/security\.ubuntu\.com/old-releases\.ubuntu\.com/g" ./sources.list
	cp ./sources.list /etc/apt/sources.list
	rm -f ./sources.list
	apt-get update
}

cd ${BASEDIR}
fix_apt_sources_for_eol_release 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
