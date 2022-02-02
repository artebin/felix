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

configure_mate_caja(){
	printf "Configuring mate-caja ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	dconf load /org/mate/caja/ < "org.mate.caja.dump"
	dconf load /org/mate/desktop/ < "org.mate.desktop.dump"
	printf "\n"
	
	printf "Use x-terminal-emulator for the action 'Open in Terminal' ...\n"
	# For an unkown reason caja-open-terminal plugin is not using x-terminal-emulator by default.
	# See <https://github.com/mate-desktop/caja-extensions/blob/master/open-terminal/caja-open-terminal.c>
	gsettings set org.mate.applications-terminal exec x-terminal-emulator
	printf "\n"
	
	printf "\n"
}

configure_mate_caja 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
