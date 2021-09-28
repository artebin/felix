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
exit_if_has_root_privileges

blueman_applet_should_not_auto_enable_bluetooth_adapter(){
	printf "Blueman applet should not auto enable the bluetooth adapter when starting (keep the saved state of the adapter) ...\n"
	
	# See <https://wiki.archlinux.org/index.php/Blueman>
	gsettings set org.blueman.plugins.powermanager auto-power-on false
	
	printf "\n"
}

blueman_applet_should_not_auto_enable_bluetooth_adapter 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
