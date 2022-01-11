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

install_xlockscreen(){
	printf "\nInstalling dependency packages ...\n\n"
	cd "${RECIPE_DIRECTORY}"
	install_package_if_not_installed "xorg-dev xtrlock"
	
	printf "\nUninstall xprintidle because it will be re-installed from the sources\n\n"
	remove_with_purge_package_if_installed "xprintidle"
	
	printf "\nInstalling xprintidle from sources\n\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/lucianposton/xprintidle
	cd xprintidle
	./configure
	make
	make install
	
	printf "\nInstalling xlockscreen ...\n\n"
	cd "${RECIPE_DIRECTORY}"
	cp xlockscreen.sh /usr/local/bin/xlockscreen
	chmod a+x /usr/local/bin/xlockscreen
	cp xlockscreen.desktop /usr/share/applications
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr xprintidle
	
	printf "\n"
}

install_xlockscreen 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
