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

function install_light_locker_settings_from_sources(){
	printf "Build and install Light Locker Settings from <https://github.com/artebin/light-locker-settings>...\n"
	
	DEPENDENCIES=( "intltool" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/artebin/light-locker-settings
	cd light-locker-settings
	./configure
	make
	make install

	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr light-locker-settings

	printf "\n"
}

# Light Locker Settings is not in the Debian repository
install_light_locker_settings_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
