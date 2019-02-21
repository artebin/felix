#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_facetime_hd(){
	echo "Installing Facetime HD ..."
	
	DEPENDENCIES=(  "linux-headers-generic"
					"git"
					"kmod"
					"libssl-dev"
					"checkinstall" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	cd "${BASEDIR}"
	git clone https://github.com/patjak/bcwc_pcie.git
	cd bcwc_pcie/firmware
	make
	make install
	
	cd "${BASEDIR}"
	cd bcwc_pcie
	make
	make install
	depmod
	modprobe -r bdc_pci
	echo "blacklist bdc_pci" >> /etc/modprobe.d/blacklist.conf
	modprobe facetimehd
	echo "facetimehd" > /etc/modules-load.d/facetimehd.conf
	
	echo "Please test your setup with teh command \'mplayer tv://\'"
	
	# Cleaning
	cd "${BASEDIR}"
	rm -fr bcwc_pcie
	
	echo
}

install_facetime_hd 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
