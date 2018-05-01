#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_mate_power_manager_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing Mate Power Manager from sources ..."
	
	# Dependencies
	apt-get install -y libtool-bin \
					   libmate-panel-applet-dev \
					   libgnome-keyring-dev \
					   libupower-glib-dev \
					   libnotify-dev \
					   libdbus-glib-1-dev \
					   libcanberra-dev \
					   yelp-tools \
					   mate-common
	
	git clone https://github.com/mate-desktop/mate-power-manager
	cd ./mate-power-manager
	./autogen.sh
	make
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./mate-power-manager
}

cd ${BASEDIR}
install_mate_power_manager_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
