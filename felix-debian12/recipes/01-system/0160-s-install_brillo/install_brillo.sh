#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix-common.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix-common.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

# See <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.

function install_brillo_from_sources(){
	printf "Install required dependenceis to build brillo <https://gitlab.com/cameronnemo/brillo>...\n"
	DEPENDENCIES=( "go-md2man" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Build and install brillo...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://gitlab.com/cameronnemo/brillo
	cd "${RECIPE_DIRECTORY}"
	cd brillo
	make
	make install
	make dist
	make install-dist
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr brillo
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

install_brillo_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

