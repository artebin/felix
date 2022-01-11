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

configure_vlc(){
	printf "Configuring vlc ...\n"
	
	printf "Adding default playlist ...\n"
	cd "${RECIPE_DIRECTORY}"
	if [[ ! -d "${HOME}/.local/share/vlc" ]]; then
		mkdir -p "${HOME}/.local/share/vlc"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.local/share/vlc/ml.xspf" "ml.xspf"
	
	printf "\n"
}

configure_vlc 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
