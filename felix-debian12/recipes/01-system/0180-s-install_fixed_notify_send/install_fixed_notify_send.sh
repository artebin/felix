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

# notify-send.sh provides a fix for libnotify on the notification IDs.

function install_fixed_notify_send(){
	printf "Remove libnotify-bin if already installed...\n"
	remove_with_purge_package_if_installed "libnotify-bin"
	
	printf "Install a fixed version of notify-send from <https://github.com/vlevit/notify-send.sh>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/vlevit/notify-send.sh
	cd notify-send.sh
	cp notify-send.sh /usr/bin/notify-send
	cp notify-action.sh /usr/bin/notify-action
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr notify-send.sh
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

install_fixed_notify_send 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
