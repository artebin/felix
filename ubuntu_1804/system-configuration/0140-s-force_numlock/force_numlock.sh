#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

force_numlock_tty(){
	echo "Forcing numlock in tty ..."
	
	if [[ -f /usr/bin/numlock ]]; then
		echo "/usr/bin/numlock already exists"
		return 1
	fi
	cd "${BASEDIR}"
	cp numlock /usr/bin/numlock
	chmod a+x /usr/bin/numlock
	
	if [[ -f /etc/systemd/system/numlock_tty.service ]]; then
		echo "/etc/systemd/system/numlock_tty.service already exists"
		return 1
	fi
	cd "${BASEDIR}"
	cp numlock_tty.service /etc/systemd/system/numlock_tty.service
	systemctl daemon-reload
	systemctl start numlock_tty.service
	systemctl status numlock_tty.service
	systemctl enable numlock_tty.service
	
	echo
}

force_numlock_xorg(){
	echo "Forcing numlock in X.org ..."
	
	install_package_if_not_installed "numlockx"
	
	if [[ -f /etc/lightdm/lightdm.conf.d/60-numlockx.conf ]]; then
		echo "/etc/lightdm/lightdm.conf.d/60-numlockx.conf already exists"
		return 1
	fi
	if [[ ! -d /etc/lightdm/lightdm.conf.d ]]; then
		mkdir /etc/lightdm/lightdm.conf.d
	fi
	cd "${BASEDIR}"
	cp 60-numlockx.conf /etc/lightdm/lightdm.conf.d/60-numlockx.conf
	
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
