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

configure_tint2(){
	cd ${RECIPE_DIR}
	
	echo "Configuring tint2 ..."
	if [ -f ~/.config/tint2 ]; then
		backup_file rename ~/.config/tint2
	fi
	mkdir -p ~/.config/tint2
	cp tint2rc ~/.config/tint2/tint2rc
	
	if [ -f ~/.config/gsimplecal/config ]; then
		backup_file rename ~/.config/gsimplecal/config
	fi
	mkdir -p ~/.config/gsimplecal
	
	cp gsimplecal.config.template gsimplecal.config
	SED_PATTERN="LOCAL_TIME_ZONE"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern ${SED_PATTERN})
	REPLACEMENT_STRING="${LOCAL_TIME_ZONE}"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" ./gsimplecal.config
	cp gsimplecal.config ~/.config/gsimplecal/config
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -f gsimplecal.config
	
	echo
}



cd ${RECIPE_DIR}
configure_tint2 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
