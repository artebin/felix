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

function install_sw_from_sources(){
	printf "Install sw from <https://github.com/artebin/sw>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone "https://github.com/artebin/sw"
	if [[ ! -d "${HOME}/.local/bin" ]]; then
		mkdir -p "${HOME}/.local/bin"
	fi
	cp sw/sw "${HOME}/.local/bin"
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr sw
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

install_sw_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
