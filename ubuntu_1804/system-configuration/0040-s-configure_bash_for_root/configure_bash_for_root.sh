#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_bash_for_root(){
	echo "Configuring bash for root ..."
	
	if [[ -f /root/.bashrc ]]; then
		backup_file rename /root/.bashrc
	fi
	
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.bashrc" /root/.bashrc
	
	echo
}

configure_bash_for_root 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
