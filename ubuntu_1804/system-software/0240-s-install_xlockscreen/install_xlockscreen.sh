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

install_xlockscreen(){
	printf "\nInstalling dependency packages ...\n\n"
	cd "${RECIPE_DIR}"
	install_package_if_not_installed "xorg-dev xtrlock"
	
	printf "\nUninstall xprintidle because it will be re-installed from the sources\n\n"
	remove_with_purge_package_if_installed "xprintidle"
	
	printf "\nInstalling xprintidle from sources\n\n"
	cd "${RECIPE_DIR}"
	git clone https://github.com/lucianposton/xprintidle
	cd xprintidle
	./configure
	make
	make install
	
	printf "\nInstalling xlockscreen ...\n\n"
	cd "${RECIPE_DIR}"
	cp xlockscreen.sh /usr/local/bin/xlockscreen
	chmod a+x /usr/local/bin/xlockscreen
	cp xlockscreen.desktop /usr/share/applications
	
	# Cleanup
	cd "${RECIPE_DIR}"
	rm -fr xprintidle
	
	printf "\n"
}

install_xlockscreen 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
