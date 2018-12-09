#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

fix_apt_sources_for_eol_release(){
	cd ${BASEDIR}
	
	# See <https://help.ubuntu.com/community/EOLUpgrades>
	echo "Fixing apt sources for EOL release ..."
	backup_file copy /etc/apt/sources.list
	cp /etc/apt/sources.list ./sources.list
	SEARCHED_PATTERN="http://.*\.ubuntu\.com/"
	ESCAPED_SEARCHED_PATTERN=$(escape_sed_pattern ${SEARCHED_PATTERN})
	REPLACEMENT_STRING="http://old-releases.ubuntu.com/"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SEARCHED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" ./sources.list
	cp ./sources.list /etc/apt/sources.list
	rm -f ./sources.list
	apt-get update
	
	echo
}

cd ${BASEDIR}

fix_apt_sources_for_eol_release 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
