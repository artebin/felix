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

install_dotfiles(){
	printf "Install dotfiles ...\n"
	
	DOTFILES_DIRECTORY="${FELIX_ROOT}/user-dotfiles"
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
