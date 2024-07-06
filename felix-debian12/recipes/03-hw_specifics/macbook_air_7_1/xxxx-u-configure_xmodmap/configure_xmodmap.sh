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

configure_xmodmap(){
	echo "Configuring xmodmap ..."
	
	if [[ -f "${HOME}/.Xmodmap" ]]; then
		backup_file rename "${HOME}/.Xmodmap"
	fi
	
	cd "${RECIPE_DIRECTORY}"
	cp Xmodmap "${HOME}/.Xmodmap"
	echo "xmodmap ${HOME}/.Xmodmap" >> ~/.xinitrc
	
	echo
}

configure_xmodmap 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
