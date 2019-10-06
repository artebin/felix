#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_root_privileges

configure_gsimplecal(){
	printf "Configuring gsimplecal ...\n"
	
	if [[ ! -d "${HOME}/.config/gsimplecal" ]]; then
		mkdir -p "${HOME}/.config/gsimplecal"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/gsimplecal/config" "${RECIPE_FAMILY_DIR}/dotfiles/.config/gsimplecal/config"
	SED_PATTERN="LOCAL_TIME_ZONE"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern ${SED_PATTERN})
	REPLACEMENT_STRING="${LOCAL_TIME_ZONE}"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" "${HOME}/.config/gsimplecal/config"
	
	printf "\n"
}

configure_gsimplecal 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
