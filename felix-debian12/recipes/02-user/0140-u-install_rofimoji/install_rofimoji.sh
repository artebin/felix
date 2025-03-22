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

install_rofimoji(){
	printf "Installing rofimoji ...\n"
	
	PYTHON_VENV_ROFIMOJI_DIR="/home/${USER}/.local/lib/rofimoji/venv"
	if [[ -d "${PYTHON_VENV_ROFIMOJI_DIR}" ]]; then
		printf "Python venv for rofimoji already exists: %s\n" "${PYTHON_VENV_ROFIMOJI_DIR}"
		printf "Deleting it...\n"
		rm -fr "${PYTHON_VENV_ROFIMOJI_DIR}"
	fi
	
	printf "Creating python venv for rofimoji: %s\n" "${PYTHON_VENV_ROFIMOJI_DIR}"
	python -m venv "${PYTHON_VENV_ROFIMOJI_DIR}"
	source "${PYTHON_VENV_ROFIMOJI_DIR}"/bin/activate
	pip install rofimoji
	
	cp rofimoji.rc ~/.config/
	chmod +x rofimoji_run.sh
	cp rofimoji_run.sh ~/.local/bin
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_rofimoji 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
