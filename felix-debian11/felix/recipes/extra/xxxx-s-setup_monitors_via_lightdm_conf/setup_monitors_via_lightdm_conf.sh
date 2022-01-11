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

setup_monitors_via_lightdm_conf(){
	printf "Setup monitors setup via lightdm configuration ...\n"
	
	if [[ -f /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh ]]; then
		echo "lightdm configuration file /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh already exists!"
		exit 1
	fi
	
	cd "${RECIPE_DIRECTORY}"
	cp 10-monitors_setup.sh /etc/lightdm/lightdm.conf.d
	
	printf "\n"
}

setup_monitors_via_lightdm_conf 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
