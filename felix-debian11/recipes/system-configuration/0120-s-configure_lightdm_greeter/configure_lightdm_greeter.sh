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

configure_lightdm_greeter(){
	printf "Configuring LightDM greeter...\n"
	
	if [[ -f /etc/lightdm/lightdm-gtk-greeter.conf ]]; then
		backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	fi
	
	# Copy GTK greeter.conf file
	cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
	
	# Do not hide users
	add_or_update_line_based_on_prefix "#greeter-hide-users=false" "greeter-hide-users=false" /etc/lightdm/lightdm.conf
	
	printf "\n"
}

configure_lightdm_greeter 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
