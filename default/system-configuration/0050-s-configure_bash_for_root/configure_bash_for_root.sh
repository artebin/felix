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
exit_if_has_not_root_privileges

configure_bash_for_root(){
	printf "Configuring bash for root...\n"
	
	if [[ -f /root/.bashrc ]]; then
		backup_file rename /root/.bashrc
	fi
	
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.bashrc" /root/.bashrc
	
	printf "\n"
}

configure_bash_for_root 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
