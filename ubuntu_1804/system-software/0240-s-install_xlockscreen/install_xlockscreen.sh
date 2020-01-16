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

install_xlockscreen(){
	printf "Installing dependencies ...\n"
	install_package_if_not_installed "xtrlock xprintidle"
	
	printf "Installing xlockscreen ...\n"
	cp xlockscreen.sh /usr/local/bin/xlockscreen
	chmod a+x /usr/local/bin/xlockscreen
	
	printf "\n"
}

install_xlockscreen 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
