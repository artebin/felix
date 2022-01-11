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
exit_if_has_not_root_privileges

install_clipnotify_from_sources(){
	printf "Installing ClipNotify from sources ...\n"
	printf "GitHub repository: <https://github.com/cdown/clipnotify>\n"
	git clone https://github.com/cdown/clipnotify
	cd "${RECIPE_DIRECTORY}/clipnotify"
	make
	cp clipnotify /usr/local/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipnotify"
	
	printf "\n"
}

install_clipmenu_from_sources(){
	printf "Installing ClipMenu from sources ...\n"
	
	printf "GitHub repository: <https://github.com/cdown/clipmenu>\n"
	git clone https://github.com/cdown/clipmenu
	cd "${RECIPE_DIRECTORY}/clipmenu"
	
	# Installing
	cp clipdel /usr/local/bin
	cp clipmenu /usr/local/bin
	cp clipmenud /usr/local/bin
	
	# Cleaning
	rm -fr "${RECIPE_DIRECTORY}/clipmenu"
	
	printf "\n"
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
