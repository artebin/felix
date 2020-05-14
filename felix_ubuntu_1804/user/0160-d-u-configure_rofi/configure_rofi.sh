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

configure_rofi(){
	printf "Configure rofi ...\n"
	
	if [[ ! -d "${HOME}/.config/rofi" ]]; then
		mkdir -p "${HOME}/.config/rofi"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/rofi/config.rasi" "${RECIPE_FAMILY_DIR}/dotfiles/.config/rofi/config.rasi"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/rofi/arc-felix.rasi" "${RECIPE_FAMILY_DIR}/dotfiles/.config/rofi/arc-felix.rasi"
	
	printf "\n"
}

configure_rofi 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
