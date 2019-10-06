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

disable_gpe66(){
	echo "Disable gpe66 (causing battery draining) ..."
	
	cp "${RECIPE_DIR}/disable_gpe66.service" /etc/systemd/system/disable_gpe66.service
	systemctl daemon-reload
	systemctl start disable_gpe66.service
	systemctl status disable_gpe66.service
	systemctl enable disable_gpe66.service
	
	echo
}

disable_gpe66 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
