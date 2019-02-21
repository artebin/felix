#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME="openbox_badge-symbolic#1.svg"

add_lightdm_greeter_badges(){
	echo "Adding lightdm greeter badges ..."
	
	cd "${RECIPE_DIR}"
	cp "${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME}" /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
	update-icon-caches /usr/share/icons/hicolor
	
	echo
}

add_lightdm_greeter_badges 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
