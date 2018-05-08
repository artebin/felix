#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_alltray_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing AllTray from sources ..."
	echo "GitHub repository: <https://github.com/bill-auger/alltray>"
	
	# Dependencies
	apt-get install -y libgtop2-dev libwnck-dev libxpm-dev
	
	# Cloning github repository
	git clone https://github.com/bill-auger/alltray
	
	# Proceed to compile and install
	cd ./alltray
	./autogen.sh
	make
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./alltray
}

cd ${BASEDIR}
install_alltray_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
