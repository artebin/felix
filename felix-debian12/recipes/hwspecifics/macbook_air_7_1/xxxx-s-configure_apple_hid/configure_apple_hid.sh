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

configure_apple_hid(){
	printf "Configuring Apple HID for using fn keys as special functions keys...\n"
	printf "options hid_apple fnmode=2\n" > /etc/modprobe.d/hid_apple.conf
	
	printf "Configuring ISO layout for Apple HID...\n"
	printf "options hid_apple iso_layout=0\n" >> /etc/modprobe.d/hid_apple.conf
	
	update-initramfs -u -k all
	
	printf "\n"
}

configure_apple_hid 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
