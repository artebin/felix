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

install_clipnotify_from_sources(){
	echo "Installing ClipNotify from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipnotify>"
	git clone https://github.com/cdown/clipnotify
	cd "${RECIPE_DIRECTORY}/clipnotify"
	make
	cp clipnotify /usr/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipnotify"
	
	echo
}

install_clipmenu_from_sources(){
	echo "Installing ClipMenu from sources ..."
	echo "GitHub repository: <https://github.com/cdown/clipmenu>"
	git clone https://github.com/cdown/clipmenu
	cd "${RECIPE_DIRECTORY}/clipmenu"
	printf "Applying patch on clipmenud for copy/paste in file managers ...\n"
	patch < ../clipmenud_190204.patch
	cp clipdel /usr/bin
	cp clipmenu /usr/bin
	cp clipmenud /usr/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipmenu"
	
	echo
}

install_clipnotify_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_clipmenu_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
