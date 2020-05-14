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

configure_tint2(){
	printf "Configuring tint2 ...\n"
	
	if [[ ! -d "${HOME}/.config/tint2" ]]; then
		mkdir -p "${HOME}/.config/tint2"
	fi
	
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/tint2/tint2rc" "${RECIPE_FAMILY_DIR}/dotfiles/.config/tint2/tint2rc"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/tint2/toggle_avahi_discover.sh" "${RECIPE_FAMILY_DIR}/dotfiles/.config/tint2/toggle_avahi_discover.sh"
	
	printf "\n"
}

configure_tint2 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
