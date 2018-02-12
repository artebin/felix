#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_dmenu_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing dmenu from sources ..."
	tar xzf dmenu-4.7.tar.gz
	cp ./dmenu-lineheight-4.7.diff ./dmenu-4.7/
	
	cd ./dmenu-4.7
	patch < dmenu-lineheight-4.7.diff
	make
	make install
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr ./dmenu-4.7/
}

cd ${BASEDIR}
install_dmenu_from_sources 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
