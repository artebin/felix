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

configure_alternatives(){
	printf "Configuring alternatives...\n"
	
	printf "Setting mate-terminal as x-terminal-emulator...\n"
	update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/mate-terminal.wrapper 900
	update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
	printf "\n"
	
	printf "Setting firefox as x-www-browser...\n"
	update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 900
	update-alternatives --set x-www-browser /usr/bin/firefox
	printf "\n"
}

configure_alternatives 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
