#!/usr/bin/env bash

source ../../../../felix.sh
source ../../../ubuntu_1804.conf
is_bash
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
	
	echo "facetimehd" > /etc/modules-load.d/facetimehd.conf
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./bcwc_pcie
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
install_facetime_hd 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
