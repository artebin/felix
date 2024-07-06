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

configure_dejavu_as_default_monospace_font(){
	printf "Configuring dejavu as default monospace font ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	if [[ ! -d "${HOME}/.config/fontconfig" ]]; then
		mkdir -p "${HOME}/.config/fontconfig"
	fi
	if [[ ! -f "${HOME}/.config/fontconfig/fonts.conf" ]]; then
		backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/fontconfig/fonts.conf" "fonts.conf"
	fi
	fc-cache -r
	
	printf "\n"
}

configure_dejavu_as_default_monospace_font 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
