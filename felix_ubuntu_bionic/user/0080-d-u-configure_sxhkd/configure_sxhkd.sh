#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_sxhkd(){
	printf "Configuring sxhkd ...\n"
	
	if [[ ! -d "${HOME}/.config/sxhkd" ]]; then
		mkdir -p "${HOME}/.config/sxhkd"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/sxhkd/sxhkdrc" "${RECIPE_FAMILY_DIR}/dotfiles/.config/sxhkd/sxhkdrc"
	
	printf "\n"
}

configure_sxhkd 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
