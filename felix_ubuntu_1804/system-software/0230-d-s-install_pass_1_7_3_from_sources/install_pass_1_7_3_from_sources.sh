#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pass_1_7_3_from_sources(){
	printf "Installing pass V1.7.3 from sources ...\n"
	
	# Download and unpack sources tarball
	wget -q https://git.zx2c4.com/password-store/snapshot/password-store-1.7.3.tar.xz
	tar xf password-store-1.7.3.tar.xz
	
	# Install
	cd "${RECIPE_DIR}"
	cd password-store-1.7.3
	make install
	
	# Cleaning
	cd "${RECIPE_DIR}"
	rm -fr password-store-1.7.3
	rm -fr password-store-1.7.3.tar.xz
	
	printf "\n"
}

install_pass_1_7_3_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
