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

configure_xmodmap(){
	echo "Configuring xmodmap ..."
	
	if [[ -f "${HOME}/.Xmodmap" ]]; then
		backup_file rename "${HOME}/.Xmodmap"
	fi
	
	cd "${RECIPE_DIR}"
	cp Xmodmap "${HOME}/.Xmodmap"
	echo "xmodmap ${HOME}/.Xmodmap" >> ~/.xinitrc
	
	echo
}

configure_xmodmap 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
