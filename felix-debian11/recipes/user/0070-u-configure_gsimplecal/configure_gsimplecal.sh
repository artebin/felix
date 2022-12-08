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
exit_if_has_root_privileges

configure_gsimplecal(){
	printf "Configuring gsimplecal ...\n"
	
	if [[ ! -d "${HOME}/.config/gsimplecal" ]]; then
		mkdir -p "${HOME}/.config/gsimplecal"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/gsimplecal/config" "${RECIPE_FAMILY_DIRECTORY}/user-dotfiles/.config/gsimplecal/config"
	SED_PATTERN="LOCAL_TIME_ZONE"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern ${SED_PATTERN})
	REPLACEMENT_STRING="${LOCAL_TIME_ZONE}"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" "${HOME}/.config/gsimplecal/config"
	
	printf "\n"
}

configure_gsimplecal 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
