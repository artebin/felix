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

configure_systemd(){
	printf "Configuring systemd...\n"
	
	SYSTEMD_CONF_FILE="/etc/systemd/system.conf"
	
	printf "Default timeout for stop operations 10 seconds ...\n"
	add_or_update_keyvalue "${SYSTEMD_CONF_FILE}" "DefaultTimeoutStopSec" "10s"
	
	printf "Reloading systemd daemon...\n"
	systemctl daemon-reload
	
	printf "\n"
}

configure_systemd 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
