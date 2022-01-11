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
	cp kpie "/usr/local/bin"
	
	# Add a desktop file
	cd "${RECIPE_DIRECTORY}"
	cp kpie.desktop /usr/share/applications
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr kpie
	
	printf "\n"
}

install_kpie_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
