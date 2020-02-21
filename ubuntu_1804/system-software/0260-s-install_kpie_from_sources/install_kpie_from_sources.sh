#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_kpie_from_sources(){
	# Install dependencies
	printf "Installing dependencies ...\n"
	install_package_if_not_installed "lua5.1 liblua5.1-0-dev libwnck-dev"
	
	# Clone the github repository
	printf "Cloning <https://github.com/skx/kpie> ...\n"
	git clone https://github.com/skx/kpie
	
	# Compile and install
	printf "Compiling and installing ...\n"
	cd kpie
	make
	if [[ ! -d "${HOME}/bin" ]]; then
		mkdir -p "${HOME}/bin"
	fi
	cp kpie "/usr/local/bin"
	
	# Add a desktop file
	cd "${RECIPE_DIR}"
	cp kpie.desktop /usr/share/applications
	
	# Cleaning
	cd "${RECIPE_DIR}"
	rm -fr kpie
	
	printf "\n"
}

install_kpie_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
