#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME="openbox_badge-symbolic#1.svg"

add_lightdm_greeter_badges(){
	echo "Adding lightdm greeter badges ..."
	
	cd "${RECIPE_DIRECTORY}"
	cp "${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME}" /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
	update-icon-caches /usr/share/icons/hicolor
	
	echo
}

add_lightdm_greeter_badges 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi