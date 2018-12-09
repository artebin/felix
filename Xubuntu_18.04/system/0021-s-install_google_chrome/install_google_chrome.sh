#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_chrome(){
	cd ${BASEDIR}
	
	echo "Installing Google Chrome from google.com"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	if [ -f /etc/apt/sources.list.d/google-chrome.list ]; then
		backup_file rename /etc/apt/sources.list.d/google-chrome.list
	fi
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
	apt-get update
	apt-get install google-chrome-stable -y
	
	echo
}

cd ${BASEDIR}

install_chrome 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi