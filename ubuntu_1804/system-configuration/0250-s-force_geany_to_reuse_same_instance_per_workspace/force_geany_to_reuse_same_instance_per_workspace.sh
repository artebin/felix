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

force_geany_to_reuse_same_instance_per_workspace(){
	echo "Force Geany to reuse same instance per workspace ..."
	
	# I cannot make it work by overriding geany.desktop in ${HOME}/.local/share/applications
	# Here we fix /usr/share/applications/geany.desktop
	
	cp "${RECIPE_DIR}/geany_one_instance_per_workspace.sh" /usr/bin/geany_one_instance_per_workspace
	chmod a+x /usr/bin/geany_one_instance_per_workspace
	sed -i "s/Exec=.*/Exec=bash geany_one_instance_per_workspace %F/" /usr/share/applications/geany.desktop
	update-desktop-database
	
	echo
}

force_geany_to_reuse_same_instance_per_workspace 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
