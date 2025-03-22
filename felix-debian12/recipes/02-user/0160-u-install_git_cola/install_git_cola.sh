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
exit_if_has_root_privileges

function install_git_cola(){
	printf "Installing git-cola from sources ...\n"
	
	HOME_LOCAL_LIB_DIRECTORY="${HOME}/.local/lib"
	if [[ ! -d "${HOME_LOCAL_LIB_DIRECTORY}" ]]; then
		mkdir -p "${HOME_LOCAL_LIB_DIRECTORY}"
	fi
	GIT_COLA_INSTALL_DIRECTORY="${HOME_LOCAL_LIB_DIRECTORY}/git-cola"
	if [[ -d "${GIT_COLA_INSTALL_DIRECTORY}" ]]; then
		printf "Deleting previous installation of git-cola in GIT_COLA_INSTALL_DIRECTORY[%s] ...\n" "${GIT_COLA_INSTALL_DIRECTORY}"
		rm -fr "${GIT_COLA_INSTALL_DIRECTORY}"
	fi
	
	cd "${HOME_LOCAL_LIB_DIRECTORY}"
	git clone https://github.com/git-cola/git-cola
	
	cd "${RECIPE_DIRECTORY}"
	cp ./git-cola "${HOME}/.local/bin"
	
	printf "\n"
}

install_git_cola 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
