#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix-common.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix-common.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

function install_engrampa(){
	printf "Install engrampa...\n"
	install_package_if_not_installed "engrampa"
	printf "\n"
}

function install_engrampa_from_sources(){
	printf "Install required dependencies to build engrampa...\n"
	DEPENDENCIES=(  "gtk-doc-tools"
			"gobject-introspection"
			"autoconf-archive"
			"libgail-3-dev"
			"libmate-desktop-dev"
			"yelp-tools" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Create required directories
	if [[ ! -d "/usr/share/aclocal" ]]; then
		mkdir -p "/usr/share/aclocal"
	fi
	if [[ ! -d "/usr/local/share/aclocal" ]]; then
		mkdir -p "/usr/local/share/aclocal"
	fi
	
	printf "Build and install mate-common from <https://github.com/mate-desktop/mate-common>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/mate-desktop/mate-common
	cd mate-common
	ACLOCAL_FLAGS="-I /usr/share/aclocal -I /usr/local/share/aclocal" ./autogen.sh --prefix=/usr
	make
	make install
	
	printf "Build and install engrampa from <https://github.com/mate-desktop/engrampa>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/mate-desktop/engrampa
	cd engrampa
	git submodule init
	git submodule update --remote --recursive
	./autogen.sh
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr mate-common
	rm -fr engrampa
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_engrampa 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_engrampa_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
