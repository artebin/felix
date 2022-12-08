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

install_user_scripts(){
	printf "Install user scripts ...\n"
	
	SCRIPTS_DIRECTORY="${FELIX_ROOT}/user-scripts"
	if [[ ! -d "${SCRIPTS_DIRECTORY}" ]]; then
		printf "Cannot find SCRIPTS_DIRECTORY[%s]\n" "${SCRIPTS_DIRECTORY}"
		exit 1
	fi
	
	# Backup existing scripts directory
	if [[ -d "${HOME}/scripts" ]]; then
		backup_file rename "${HOME}/scripts"
	fi
	cp -R "${SCRIPTS_DIRECTORY}" "${HOME}/scripts"
	
	printf "\n"
}

install_user_scripts 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
