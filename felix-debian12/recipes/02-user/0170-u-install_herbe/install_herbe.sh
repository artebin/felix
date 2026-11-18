#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

function install_herbe(){
	printf "Installing herbe from sources ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/dudik/herbe
	cd herbe
	
	# Apply patch herbe-xrandr-all-monitors.diff which adds:
	#   - https://patch-diff.githubusercontent.com/raw/dudik/herbe/pull/11.diff for using Xresources
	#   - location CENTER
	#   - show the notification in all monitors Xrandr
	patch -p1 <../herbe-xrandr-all-monitors.diff
	
	# Compile and add herbe to ${HOME}/.local/bin
	make
	cp ./herbe "${HOME}/.local/bin"
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr herbe
	
	printf "\n"
}

install_herbe 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
