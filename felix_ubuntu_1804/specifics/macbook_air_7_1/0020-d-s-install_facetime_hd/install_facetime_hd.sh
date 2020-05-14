#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

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
	
	cd "${RECIPE_DIR}"
	git clone https://github.com/patjak/bcwc_pcie.git
	cd bcwc_pcie/firmware
	make
	make install
	
	cd "${RECIPE_DIR}"
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
	cd "${RECIPE_DIR}"
	rm -fr bcwc_pcie
	
	echo
}

install_facetime_hd 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
