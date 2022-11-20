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

start_vnc_server_at_login(){
	printf "Start VNC server at login ...\n"
	
	if [[ ! -d "${HOME}/.xsessionrc.d" ]]; then
		mkdir -p "${HOME}/.xsessionrc.d"
	fi
	
	cd "${RECIPE_DIRECTORY}"
	cp "99_start_vnc_server.sh" "${HOME}/.xsessionrc.d"
	
	printf "Please execute 'vncpasswd' in order to set your VNC password\n"
	
	printf "\n"
}

start_vnc_server_at_login 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
