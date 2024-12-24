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

function install_geany(){
	printf "Install Geany...\n"
	install_package_if_not_installed "geany" "geany-plugins"
	printf "\n"
}

function install_geany_from_sources(){
	printf "Install required dependencies to build Geany...\n"
	DEPENDENCIES=(  "intltool"
			"libwebkit2gtk-4.1-dev "
			"libvte-2.91-dev"
			"libgtkspell3-3-dev"
			"libgit2-dev"
			"docbook-utils" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Build and install Geany from <https://git.geany.org/git/geany>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://git.geany.org/git/geany
	cd geany
	./autogen.sh
	./configure
	make
	make install
	
	printf "Build and install Geany plugins from <https://git.geany.org/git/geany-plugins>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://git.geany.org/git/geany-plugins
	cd geany-plugins
	./autogen.sh
	./configure
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr ./geany
	rm -fr ./geany-plugins
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_geany 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_geany_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
