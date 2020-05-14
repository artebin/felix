#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY\%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_fdpowermon(){
	printf "Configuring fdpowermon ...\n"
	
	if [[ ! -d "${HOME}/.config/fdpowermon" ]]; then
		mkdir -p "${HOME}/.config/fdpowermon"
	fi
	
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/fdpowermon/theme.cfg" "${RECIPE_FAMILY_DIR}/dotfiles/.config/fdpowermon/theme.cfg"
	
	printf "\n"
}

configure_fdpowermon 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
