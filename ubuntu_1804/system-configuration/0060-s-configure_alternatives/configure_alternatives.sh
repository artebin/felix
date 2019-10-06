#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_alternatives(){
	echo "Configuring alternatives ..."
	
	echo "Setting mate-terminal as x-terminal-emulator ..."
	update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
	echo
	
	echo "Setting firefox as x-www-browser ..."
	update-alternatives --set x-www-browser /usr/bin/firefox
	echo
}

configure_alternatives 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
