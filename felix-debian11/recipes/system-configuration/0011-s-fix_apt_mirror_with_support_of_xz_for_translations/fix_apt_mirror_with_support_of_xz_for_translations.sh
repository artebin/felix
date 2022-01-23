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

fix_apt_mirror_with_support_of_xz_for_translations(){
	printf "Fix apt-mirror with support of xz for translations...\n"
	printf "See <https://github.com/apt-mirror/apt-mirror/issues/125>\n"
	
	cd "${RECIPE_DIRECTORY}"
	patch /usr/bin/apt-mirror <apt-mirror.fix_support_xz_for_translations.patch
	
	printf "\n"
}

fix_apt_mirror_with_support_of_xz_for_translations 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
