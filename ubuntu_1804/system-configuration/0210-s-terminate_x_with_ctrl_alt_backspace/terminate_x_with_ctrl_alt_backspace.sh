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

terminate_x_with_ctrl_alt_backspace(){
	echo "Allow terminate X server with <Ctrl><Alt>Backspace ..."
	
	cd "${RECIPE_DIR}"
	cp 90-zap.conf /usr/share/X11/xorg.conf.d/90-zap.conf
	
	echo
}

terminate_x_with_ctrl_alt_backspace 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
