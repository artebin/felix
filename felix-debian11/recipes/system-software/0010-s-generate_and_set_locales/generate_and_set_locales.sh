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

set_locales(){
	printf "Setting the locales ...\n"
	for LOCALE in ${LOCALES_TO_GENERATE}; do
		printf "  ${LOCALE}%s\n"
		update_line_based_on_prefix "# ${LOCALE}" "${LOCALE} UTF-8" /etc/locale.gen 
	done
	printf "\n"
	
	locale-gen
	printf "\n"
	
	printf "Updating /etc/default/locale ...\n"
	update-locale LANGUAGE="${LOCALE_TO_USE_LANGUAGE}"
	update-locale LANG="${LOCALE_TO_USE_LANG}"
	update-locale LC_ALL="${LOCALE_TO_USE_LC_ALL}"
	update-locale LC_COLLATE="${LOCALE_TO_USE_LC_COLLATE}"
	update-locale LC_NUMERIC="${LOCALE_TO_USE_LC_NUMERIC}"
	update-locale LC_TIME="${LOCALE_TO_USE_LC_TIME}"
	update-locale LC_MONETARY="${LOCALE_TO_USE_LC_MONETARY}"
	update-locale LC_PAPER="${LOCALE_TO_USE_LC_PAPER}"
	update-locale LC_NAME="${LOCALE_TO_USE_LC_NAME}"
	update-locale LC_ADDRESS="${LOCALE_TO_USE_LC_ADDRESS}"
	update-locale LC_TELEPHONE="${LOCALE_TO_USE_LC_TELEPHONE}"
	update-locale LC_MEASUREMENT="${LOCALE_TO_USE_LC_MEASUREMENT}"
	update-locale LC_IDENTIFICATION="${LOCALE_TO_USE_LC_IDENTIFICATION}"
	printf "\n"
	
	printf "/etc/default/locale:\n"
	cat /etc/default/locale
	printf  "\n"
	
	printf "\n"
}

set_locales 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
