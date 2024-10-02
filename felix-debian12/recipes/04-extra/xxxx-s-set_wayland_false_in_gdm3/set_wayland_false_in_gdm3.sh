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
exit_if_has_not_root_privileges

function disable_wayland_in_gdm3(){
	printf "Disable Wayland in GDM3 ...\n"
	
	GDM3_DAEMON_CONF_FILE="/etc/gdm3/daemon.conf"
	update_line_based_on_prefix '#WaylandEnable=' 'WaylandEnable=false' "${GDM3_DAEMON_CONF_FILE}"
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
disable_wayland_in_gdm3 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
