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

install_geany_from_sources(){
	printf "Install Geany from sources ...\n"
	
	# Install dependencies
	printf "Installing dependencies...\n"
	install_package_if_not_installed "intltool" "libwebkit2gtk-4.0-dev" "libgtkspell3-3-dev"
	
	# Clone Geany git repository
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/geany/geany
	
	# Compile and install Geany
	printf "Compiling and installing Geany...\n"
	cd "${RECIPE_DIRECTORY}"
	cd geany
	./autogen.sh
	./configure
	make
	make install
	
	# Clone Geany plugins git repository
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/geany/geany-plugins
	
	# Compile and install Geany plugins
	printf "Compiling and installing Geany plugins\n"
	cd "${RECIPE_DIRECTORY}"
	cd geany-plugins
	./autogen.sh
	./configure
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr ./geany
	rm -fr ./geany-plugins
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_geany_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
