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

install_skype(){
	echo "Installing Skype from skype.com ..."
	
	# Download the package and install it
	cd ${RECIPE_DIR}
	wget https://go.skype.com/skypeforlinux-64.deb
	dpkg -i skypeforlinux-64.deb
	
	# Cleanup
	cd ${RECIPE_DIR}
	rm -f ./skypeforlinux-64.deb
	rm -fr ~/.rpmdb
	rm -fr ~/.wget-hsts
	
	echo
}

fix_tray_icon(){
	# Fix the tiled tray icon/app indicator see <https://answers.microsoft.com/en-us/skype/forum/skype_linux-skype_startms-skype_installms/system-tray-icon-in-xfce/d3f162bf-0bbf-481b-90a1-f43cae9a86cc?page=5>
	cd ${RECIPE_DIR}
	wget https://drive.google.com/open?id=1jWNVnN0gaaOqghhoa_t0WKPPZka4hAMC >app.asar
	cp app.asar /usr/share/skypeforlinux/resources/app.asar
}



cd ${RECIPE_DIR}
install_skype 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
