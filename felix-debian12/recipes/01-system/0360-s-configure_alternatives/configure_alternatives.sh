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

configure_alternatives(){
	printf "Configuring alternatives...\n"
	
	printf "Setting terminator as x-terminal-emulator...\n"
	update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/terminator 900
	update-alternatives --set x-terminal-emulator /usr/bin/terminator
	printf "\n"
	
	printf "Setting firefox as x-www-browser...\n"
	update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox-esr 900
	update-alternatives --set x-www-browser /usr/bin/firefox-esr
	printf "\n"
	
	printf "Setting firefox as gnome-www-browser...\n"
	update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox-esr 900
	update-alternatives --set gnome-www-browser /usr/bin/firefox-esr
	printf "\n"
}

configure_alternatives 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
