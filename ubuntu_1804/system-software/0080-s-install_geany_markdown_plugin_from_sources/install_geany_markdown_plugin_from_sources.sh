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

install_geany_markdown_plugin_from_sources(){
	echo "Install Geany / Markdown plugin from sources ..."
	
	# Install dependencies
	apt-get install -y install intltool
	apt-get install -y libwebkit2gtk-4.0-dev
	
	# Clone git repository
	cd ${RECIPE_DIR}
	git clone http://github.com/geany/geany-plugins
	
	# Compile and install
	cd ${RECIPE_DIR}
	cd geany-plugins
	./autogen.sh
	./configure
	cd markdown
	make
	make install
	
	# Clean
	cd ${RECIPE_DIR}
	rm -fr ./geany-plugins
	
	echo
}



cd ${RECIPE_DIR}
install_geany_markdown_plugin_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
