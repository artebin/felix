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

install_mps_youtube_from_sources(){
	echo "Install mps-youtube from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "python3-pip" "pandoc"
	
	# Install youtube-dl from sources
	cd ${RECIPE_DIR}
	git clone https://github.com/rg3/youtube-dl
	cd youtube-dl
	make
	make install
	python3 setup.py install
	
	# Install mps-youtube and other dependencies
	pip3 install dbus-python pygobject
	pip3 install colorama
	pip3 install mps-youtube
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr youtube-dl
	
	echo
}



cd ${RECIPE_DIR}
install_mps_youtube_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
