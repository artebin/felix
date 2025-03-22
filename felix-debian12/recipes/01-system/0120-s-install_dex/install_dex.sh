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

function install_dex(){
	printf "Install dex...\n"
	install_package_if_not_installed "dex"
	printf "\n"
}

function install_dex_from_sources(){
	printf "Install required dependencies to build dex...\n"
	DEPENDENCIES=( "python3-sphinx" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Build and install dex from <https://github.com/jceb/dex>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/jceb/dex
	
	printf "Apply a patch to dex for supporting 'Terminal=(true|false)' property in .desktop files...\n"
	printf "See <https://github.com/jceb/dex/issues/33>\n"
	cd dex
	patch dex < ../fix_terminal_property.patch
	
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr dex
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_dex 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_dex_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
