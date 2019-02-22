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

set_locales(){
	echo "Generating locales ..."
	locale-gen ${LOCALES_TO_GENERATE}
	
	echo "Setting locales ..."
	update-locale LANG="${LOCALE_TO_USE_LANG}"
	update-locale LC_NUMERIC="${LOCALE_TO_USE_LC_NUMERIC}"
	update-locale LC_TIME="${LOCALE_TO_USE_LC_TIME}"
	update-locale LC_MONETARY="${LOCALE_TO_USE_LC_MONETARY}"
	update-locale LC_PAPER="${LOCALE_TO_USE_LC_PAPER}"
	update-locale LC_NAME="${LOCALE_TO_USE_LC_NAME}"
	update-locale LC_ADDRESS="${LOCALE_TO_USE_LC_ADDRESS}"
	update-locale LC_TELEPHONE="${LOCALE_TO_USE_LC_TELEPHONE}"
	update-locale LC_MEASUREMENT="${LOCALE_TO_USE_LC_MEASUREMENT}"
	update-locale LC_IDENTIFICATION="${LOCALE_TO_USE_LC_IDENTIFICATION}"
	
	echo
}

set_locales 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
