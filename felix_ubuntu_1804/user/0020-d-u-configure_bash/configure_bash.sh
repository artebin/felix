#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_bash(){
	printf "Configuring bash ...\n"
	
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.bashrc" "${RECIPE_FAMILY_DIR}/dotfiles/.bashrc"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.bashrc.d" "${RECIPE_FAMILY_DIR}/dotfiles/.bashrc.d"
	
	printf "\n"
}

configure_bash 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
