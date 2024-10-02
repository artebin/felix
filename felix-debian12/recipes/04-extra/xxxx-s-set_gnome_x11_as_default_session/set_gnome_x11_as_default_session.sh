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

function set_gnome_x11_as_default_session(){
	printf "Set GNOME X11 as default session ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	mkdir -p "/var/lib/AccountsService/users"
	USER_ACCOUNT_SERVICE_FILE="/var/lib/AccountsService/users/$(whoami)"
	if [[ ! -f "${USER_ACCOUNT_SERVICE_FILE}" ]]; then
		cp account_service_user "${USER_ACCOUNT_SERVICE_FILE}"
		update_line_based_on_prefix 'Icon=' '/home/$(whoami)/.face' "${USER_ACCOUNT_SERVICE_FILE}"
	fi
	update_line_based_on_prefix 'XSession=' 'gnome-session' "${USER_ACCOUNT_SERVICE_FILE}"
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
set_gnome_x11_as_default_session 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
