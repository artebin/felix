#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_light_locker_settings_from_sources(){
	printf "Install Light Locker Settings from sources ...\n"
	
	printf "Cloning GIT repository <https://github.com/Antergos/light-locker-settings> ...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/Antergos/light-locker-settings
	
	# Build and install
	cd "${RECIPE_DIRECTORY}"
	cd light-locker-settings
	./configure
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr light-locker-settings
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_light_locker_settings_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
