#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_geany(){
	echo "Configuring Geany ..."
	if [[ -d "${HOME}/.config/geany" ]]; then
		backup_file rename "${HOME}/.config/geany"
	fi
	mkdir -p "${HOME}/.config/geany"
	
	#Geany main configuration
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/geany/geany.conf" "${HOME}/.config/geany"
	
	# Geany keybindings
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/geany/keybindings.conf" "${HOME}/.config/geany"
	
	# Geany filedefs
	mkdir -p "${HOME}/.config/geany/filedefs"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/geany/filedefs/filetypes.common" "${HOME}/.config/geany/filedefs"
	
	# GitHub markdown CSS
	mkdir -p "${HOME}/.config/geany/plugins/markdown"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/geany/plugins/markdown/github-markdown.html" "${HOME}/.config/geany/plugins/markdown"
	
	echo
}

configure_geany 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
