#!/bin/bash

source ../../../common.sh
check_shell
exit_if_has_not_root_privileges

install_facetime_hd(){
	cd ${BASEDIR}
	
	echo "Installing FacetimeHD ..."
	
	apt-get install -y linux-headers-generic git kmod libssl-dev checkinstall
	
	cd ${BASEDIR}
	git clone https://github.com/patjak/bcwc_pcie.git
	cd ./bcwc_pcie/firmware
	make
	make install
	
	cd ${BASEDIR}
	cd ./bcwc_pcie/
	make
	make install
	depmod
	modprobe -r bdc_pci
	echo "blacklist bdc_pci" >> /etc/modprobe.d/blacklist.conf
	modprobe facetimehd
	echo "You can test your configuration with \'mplayer tv://\'"
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./bcwc_pcie
}

cd ${BASEDIR}
install_facetime_hd 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
