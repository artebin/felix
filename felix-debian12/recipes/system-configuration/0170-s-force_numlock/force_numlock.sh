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

force_numlock_tty(){
	printf "Forcing numlock in tty...\n"
	
	cd "${RECIPE_DIRECTORY}"
	cp numlock /usr/bin/numlock
	chmod a+x /usr/bin/numlock
	
	cd "${RECIPE_DIRECTORY}"
	cp numlock_tty.service /etc/systemd/system/numlock_tty.service
	systemctl daemon-reload
	systemctl start numlock_tty.service
	systemctl status numlock_tty.service
	systemctl enable numlock_tty.service
	
	printf "\n"
}

force_numlock_xorg(){
	printf "Forcing numlock in X.org...\n"
	
	install_package_if_not_installed "numlockx"
	if [[ ! -f "/etc/default/numlockx" ]]; then
		printf "Cannot find: /etc/default/numlockx\n"
		return 1
	fi
	add_or_update_keyvalue "/etc/default/numlockx" "NUMLOCK" "on"
	
	if [[ ! -d /etc/lightdm/lightdm.conf.d ]]; then
		mkdir /etc/lightdm/lightdm.conf.d
	fi
	cd "${RECIPE_DIRECTORY}"
	cp 60-numlockx.conf /etc/lightdm/lightdm.conf.d
	
	printf "\n"
}

force_numlock_tty 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

force_numlock_xorg 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
