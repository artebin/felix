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

install_pasystray(){
	echo "Installing pasystray from sources ..."
	
	# Install dependencies
	DEPENDENCIES=(  "libavahi-client-dev"
					"libavahi-common-dev"
					"libavahi-compat-libdnssd-dev"
					"libavahi-core-dev"
					"libavahi-glib-dev"
					"libavahi-gobject-dev"
					"libavahi-ui-gtk3-dev"
					"libappindicator-dev"
					"libappindicator3-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repository <https://github.com/christophgysin/pasystray>
	cd "${RECIPE_DIR}"
	git clone https://github.com/christophgysin/pasystray
	
	# Compile and install
	cd "${RECIPE_DIR}"
	cd pasystray
	./bootstrap.sh
	./configure
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIR}"
	rm -fr pasystray
	
	echo
}

cd "${RECIPE_DIR}"
install_pasystray 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
