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
exit_if_has_root_privileges

configure_gsimplecal(){
	echo "Configuring gsimplecal ..."
	if [[ -d "${HOME}/.config/gsimplecal" ]]; then
		backup_file rename "${HOME}/.config/gsimplecal"
	fi
	mkdir -p "${HOME}/.config/gsimplecal"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/gsimplecal/config" "${HOME}/.config/gsimplecal/config"
	SED_PATTERN="LOCAL_TIME_ZONE"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern ${SED_PATTERN})
	REPLACEMENT_STRING="${LOCAL_TIME_ZONE}"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" "${HOME}/.config/gsimplecal/config"
	echo
}

configure_gsimplecal 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
