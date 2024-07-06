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

install_felix_themes(){
	printf "Install felix-themes ...\n"
	
	printf "Cloning https://github.com/felix/felix-themes\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/artebin/felix-themes
	cd felix-themes
	./install.sh
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr felix-themes
	
	printf "\n"
}

install_felix_themes 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
