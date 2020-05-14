#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY\%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

force_numlock_tty(){
	echo "Forcing numlock in tty ..."
	
	if [[ -f /usr/bin/numlock ]]; then
		echo "/usr/bin/numlock already exists"
		return 1
	fi
	cp "${RECIPE_DIRECTORY}/numlock" /usr/bin/numlock
	chmod a+x /usr/bin/numlock
	
	if [[ -f /etc/systemd/system/numlock_tty.service ]]; then
		echo "/etc/systemd/system/numlock_tty.service already exists"
		return 1
	fi
	cp "${RECIPE_DIRECTORY}/numlock_tty.service" /etc/systemd/system/numlock_tty.service
	systemctl daemon-reload
	systemctl start numlock_tty.service
	systemctl status numlock_tty.service
	systemctl enable numlock_tty.service
	
	echo
}

force_numlock_xorg(){
	echo "Forcing numlock in X.org ..."
	
	install_package_if_not_installed "numlockx"
	if [[ ! -f "/etc/default/numlockx" ]]; then
		printf "Cannot find: /etc/default/numlockx\n"
		return 1
	fi
	add_or_update_keyvalue "/etc/default/numlockx" "NUMLOCK" "on"
	
	if [[ -f /etc/lightdm/lightdm.conf.d/60-numlockx.conf ]]; then
		echo "/etc/lightdm/lightdm.conf.d/60-numlockx.conf already exists"
		return 1
	fi
	if [[ ! -d /etc/lightdm/lightdm.conf.d ]]; then
		mkdir /etc/lightdm/lightdm.conf.d
	fi
	cp "${RECIPE_DIRECTORY}/60-numlockx.conf" /etc/lightdm/lightdm.conf.d
	
	echo
}

force_numlock_tty 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

force_numlock_xorg 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
