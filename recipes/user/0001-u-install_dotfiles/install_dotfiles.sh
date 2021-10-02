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

install_dotfiles(){
	printf "Install dotfiles ...\n"
	
	DOTFILES_DIRECTORY="${RECIPE_FAMILY_DIRECTORY}/dotfiles"
	if [[ ! -d "${DOTFILES_DIRECTORY}" ]]; then
		printf "Cannot find DOTFILES_DIRECTORY[%s]\n" "${DOTFILES_DIRECTORY}"
		exit 1
	fi
	
	shopt -s dotglob
	for DOTFILES_ELEMENT in "${DOTFILES_DIRECTORY}"/*; do
		DOTFILES_ELEMENT_NAME=$(basename "${DOTFILES_ELEMENT}")
		backup_by_rename_if_exists_and_copy_replacement "${HOME}/${DOTFILES_ELEMENT_NAME}" "${DOTFILES_ELEMENT}"
	done
	
	printf "\n"
}

install_dotfiles 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
