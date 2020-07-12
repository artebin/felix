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

install_brillo_from_sources(){
	echo "Install brillo from sources ..."
	
	# See <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.
	
	# Install dependencies
	install_package_if_not_installed "go-md2man"
	
	# Clone repository
	cd "${RECIPE_DIRECTORY}"
	git clone https://gitlab.com/cameronnemo/brillo
	
	# Compile and install
	cd "${RECIPE_DIRECTORY}"
	cd brillo
	make
	make install
	make dist
	make install-dist
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr brillo
	
	echo
}



cd "${RECIPE_DIRECTORY}"
install_brillo_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
