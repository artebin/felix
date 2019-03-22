#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_tint2_from_sources(){
	printf "Installing tint2 from sources ...\n"
	
	# Install dependencies
	DEPENDENCIES=( "libimlib2-dev" )
	if [[ "${#DEPENDENCIES[@]}" -ne 0 ]]; then
		install_package_if_not_installed "${DEPENDENCIES[@]}"
	fi
	
	# Clone git repository <https://gitlab.com/o9000/tint2.git>
	cd "${RECIPE_DIR}"
	git clone https://gitlab.com/o9000/tint2.git
	
	# Compile and install
	cd "${RECIPE_DIR}"
	cd tint2
	git checkout 16.6.1
	mkdir build
	cd build
	cmake ..
	make -j4
	make install
	update-icon-caches /usr/share/icons/hicolor
	update-mime-database /usr/local/share/mime
	
	# Cleanup
	cd "${RECIPE_DIR}"
	rm -fr tint2
	
	printf "\n"
}

install_tint2_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
