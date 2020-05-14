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

configure_openbox(){
	printf "Configuring openbox ...\n"
	
	if [[ ! -d "${HOME}/.config/openbox" ]]; then
		mkdir -p "${HOME}/.config/openbox"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/openbox/autostart" "${RECIPE_FAMILY_DIR}/dotfiles/.config/openbox/autostart"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/openbox/rc.xml" "${RECIPE_FAMILY_DIR}/dotfiles/.config/openbox/rc.xml"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/openbox/menu.xml" "${RECIPE_FAMILY_DIR}/dotfiles/.config/openbox/menu.xml"
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/openbox/ob-randr.py" "${RECIPE_FAMILY_DIR}/dotfiles/.config/openbox/ob-randr.py"
	
	printf "\n"
}

configure_openbox 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
