#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

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
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/patjak/bcwc_pcie.git
	cd bcwc_pcie/firmware
	make
	make install
	
	cd "${RECIPE_DIRECTORY}"
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
	cd "${RECIPE_DIRECTORY}"
	rm -fr bcwc_pcie
	
	echo
}

install_facetime_hd 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
