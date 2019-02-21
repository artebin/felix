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
exit_if_has_not_root_privileges

configure_trackpad_mtrack(){
	echo "Configuring trackpad mtrack ..."
	
	install_package_if_not_installed "xserver-xorg-input-mtrack"
	
	# For reference, the X11 mouse button numbering:
	#   1 = left button
	#   2 = middle button (pressing the scroll wheel)
	#   3 = right button
	#   4 = turn scroll wheel up
	#   5 = turn scroll wheel down
	#   6 = push scroll wheel left
	#   7 = push scroll wheel right
	#   8 = 4th button (aka browser backward button)
	#   9 = 5th button (aka browser forward button)
	#
	# See <http://xahlee.info/linux/linux_x11_mouse_button_number.html>.
	
	cd "${RECIPE_DIR}"
	cp 80-mtrack.conf /usr/share/X11/xorg.conf.d
	
	echo
}

configure_trackpad_mtrack 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
