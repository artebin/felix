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

function install_eom(){
	printf "Installing eom...\n"
	install_package_if_not_installed "eom"
	printf "\n"
}

function install_eom_from_sources(){
	printf "Install required dependencies to build eom...\n"
	DEPENDENCIES=(  "libpeas-dev"
			"libjpeg9-dev"
			"libturbojpeg0-dev"
			"libexif-dev"
			"libexif-gtk-dev"
			"liblcms2-dev"
			"exempi"
			"libexempi-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Build and install eom from <https://github.com/mate-desktop/eom>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/mate-desktop/eom
	cd eom
	./autogen.sh
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr eom
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_eom 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_eom_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
