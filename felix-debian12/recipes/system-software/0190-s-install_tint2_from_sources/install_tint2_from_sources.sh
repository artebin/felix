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

install_tint2_from_sources(){
	printf "Installing tint2 from sources ...\n"
	
	# Install dependencies
	DEPENDENCIES=( 
		"libimlib2-dev"
		"librsvg2-dev"
		"libstartup-notification0-dev"
	)
	if [[ "${#DEPENDENCIES[@]}" -ne 0 ]]; then
		install_package_if_not_installed "${DEPENDENCIES[@]}"
	fi
	
	# Clone git repository <https://gitlab.com/o9000/tint2.git>
	cd "${RECIPE_DIRECTORY}"
	git clone https://gitlab.com/o9000/tint2.git
	
	# Compile and install
	cd "${RECIPE_DIRECTORY}"
	cd tint2
	git checkout 17.0.2
	mkdir build
	cd build
	
	# Buid expects /usr/local/share/mime/packages to exist
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

install_tint2_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
