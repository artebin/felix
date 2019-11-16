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

install_gtkxset_from_sources(){
	printf "Installing gtkxset V0.3.1 from sources ...\n"
	
	# Unpack sources tarball
	tar xzf gtkxset-0.3.1.tar.gz
	
	# Compile and install
	cd "${RECIPE_DIR}"
	cd gtkxset
	bash install.sh
	
	# Cleaning
	cd "${RECIPE_DIR}"
	rm -fr gtkxset
	
	printf "\n"
}

install_gtkxset_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
