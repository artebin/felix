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

function install_tint2(){
	printf "Install tint2...\n"
	install_package_if_not_installed "tint2"
	printf "\n"
}

function install_tint2_from_sources(){
	printf "Install required dependencies to build tint2...\n"
	DEPENDENCIES=(  "libimlib2-dev"
			"librsvg2-dev"
			"libstartup-notification0-dev"
	)
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Build and install tint2 from <https://gitlab.com/o9000/tint2>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://gitlab.com/o9000/tint2
	cd tint2
	git checkout 17.0.2
	mkdir build
	cd build
	
	# Build expects /usr/local/share/mime/packages to exist
	mkdir -p /usr/local/share/mime/packages to exist
	
	cmake .. -DENABLE_TINT2CONF=OFF
	make -j4
	make install
	update-icon-caches /usr/share/icons/hicolor
	update-mime-database /usr/local/share/mime
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr tint2
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_tint2 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_tint2_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
