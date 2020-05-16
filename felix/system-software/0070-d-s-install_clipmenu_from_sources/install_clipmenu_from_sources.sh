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
	printf "Installing ClipNotify from sources ...\n"
	printf "GitHub repository: <https://github.com/cdown/clipnotify>\n"
	git clone https://github.com/cdown/clipnotify
	cd "${RECIPE_DIRECTORY}/clipnotify"
	make
	cp clipnotify /usr/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipnotify"
	
	printf "\n"
}

install_clipmenu_from_sources(){
	printf "Installing ClipMenu from sources ...\n"
	printf "GitHub repository: <https://github.com/cdown/clipmenu>\n"
	git clone https://github.com/cdown/clipmenu
	cd "${RECIPE_DIRECTORY}/clipmenu"
	
	#NJ:20-05-15: patch is not applicable on most recent version of clipmenud
	#printf "Applying patch on clipmenud for copy/paste in file managers ...\n"
	#patch < ../clipmenud_190204.patch
	
	cp clipdel /usr/bin
	cp clipmenu /usr/bin
	cp clipmenud /usr/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipmenu"
	
	printf "\n"
}

install_clipmenu_from_archived_sources(){
	printf "Installing ClipMenu from sources ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	unzip clipmenu-develop-180506-0111.zip
	cd "clipmenu-develop"
	
	printf "Applying patch on clipmenud for copy/paste in file managers ...\n"
	patch < ../clipmenud_190204.patch
	
	cp clipdel /usr/bin
	cp clipmenu /usr/bin
	cp clipmenud /usr/bin
	
	# Cleaning
	#rm -fr "${RECIPE_DIRECTORY}/clipmenu"
	
	printf "\n"
}

install_clipnotify_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_clipmenu_from_archived_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
