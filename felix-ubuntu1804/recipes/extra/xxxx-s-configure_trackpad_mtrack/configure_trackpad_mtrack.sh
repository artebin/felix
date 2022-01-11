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

configure_trackpad_mtrack(){
	if [[ "${XORG_INPUT_DRIVER}" != "mtrack" ]]; then
		printf "This recipe is not applicable (XORG_INPUT_DRIVER: ${XORG_INPUT_DRIVER})\n"
		return
	fi
	
	printf "Configuring trackpad mtrack...\n"
	
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
	
	cd "${RECIPE_DIRECTORY}"
	cp 80-mtrack.conf /usr/share/X11/xorg.conf.d
	
	printf "\n"
}

configure_trackpad_mtrack 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
