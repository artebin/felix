#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

install_clipmenu_from_sources(){
	cd ${BASEDIR}
	
	# ClipNotify
	cd ${BASEDIR}
	echo "Installing ClipNotify from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipnotify>"
	git clone https://github.com/cdown/clipnotify
	cd ./clipnotify
	make
	cp ./clipnotify /usr/bin
	
	# ClipMenu
	cd ${BASEDIR}
	echo "Installing ClipMenu from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipmenu>"
	git clone https://github.com/cdown/clipmenu
	cd ./clipmenu
	cp ./clipdel /usr/bin
	cp ./clipmenu /usr/bin
	cp ./clipmenud /usr/bin
	
	# I can not make it work with the service
	# It will be executed via openbox autostart
	#cp ./init/clipmenud.service /etc/systemd/system
	#systemctl daemon-reload
	#systemctl start clipmenud.service
	#systemctl status clipmenud.service
	#systemctl enable clipmenud.service
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./clipnotify
	rm -fr ./clipmenu
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
install_clipmenu_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
