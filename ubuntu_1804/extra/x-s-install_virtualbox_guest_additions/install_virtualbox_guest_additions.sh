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

install_virtualbox_guest_additions(){
	echo "Installing VirtualBox guest additions ..."
	
	DEPENDENCIES=(  "virtualbox-guest-dkms-hwe"
			"virtualbox-guest-utils"
			"virtualbox-guest-x11" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	echo
}

install_virtualbox_guest_additions 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
