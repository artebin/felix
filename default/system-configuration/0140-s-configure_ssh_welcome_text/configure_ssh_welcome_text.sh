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

configure_ssh_welcome_text(){
	printf "Setting SSH welcome text...\n"
	
	printf "Disabling all previous 'message of the day'...\n"
	cd /etc/update-motd.d
	for FILE in ./*; do
		backup_file rename "${FILE}"
	done
	chmod a-x ./*
	
	printf "Adding Tux Welcome Dude...\n"
	cd "${RECIPE_DIRECTORY}"
	cp 00-welcome-dude /etc/update-motd.d/00-welcome-dude
	chmod 744 /etc/update-motd.d/00-welcome-dude
	cp tux /etc/update-motd.d/tux
	chmod 644 /etc/update-motd.d/tux
	
	printf "\n"
}

configure_ssh_welcome_text 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
