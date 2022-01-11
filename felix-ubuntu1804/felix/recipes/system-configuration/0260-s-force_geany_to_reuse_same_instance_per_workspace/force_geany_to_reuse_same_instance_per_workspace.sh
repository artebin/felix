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

force_geany_to_reuse_same_instance_per_workspace(){
	printf "Force Geany to reuse same instance per workspace...\n"
	
	cp "${RECIPE_DIRECTORY}/geany_one_instance_per_workspace.sh" /usr/local/bin/geany_one_instance_per_workspace
	chmod a+x /usr/local/bin/geany_one_instance_per_workspace
	
	# I cannot make it work by overriding geany.desktop in ${HOME}/.local/share/applications
	# Here we fix /usr/share/applications/geany.desktop
	sed -i "s/Exec=.*/Exec=bash geany_one_instance_per_workspace %F/" /usr/share/applications/geany.desktop
	update-desktop-database
	
	printf "\n"
}

force_geany_to_reuse_same_instance_per_workspace 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
