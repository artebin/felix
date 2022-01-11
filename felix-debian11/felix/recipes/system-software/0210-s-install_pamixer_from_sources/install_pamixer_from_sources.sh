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

install_pamixer_from_sources(){
	printf "Installing pamixer from sources ...\n"
	
	printf "Installing dependencies ...\n"
	install_package_if_not_installed "libboost-all-dev"
	
	# Clone git repository
	git clone https://github.com/cdemoulins/pamixer.git
	
	# Build and install
	cd "${RECIPE_DIRECTORY}"
	cd pamixer
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr pamixer
	
	printf "\n"
}

install_pamixer_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
