#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_lightdm_greeter(){
	echo "Configuring LightDM greeter ..."
	
	if [[ -f /etc/lightdm/lightdm-gtk-greeter.conf ]]; then
		backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	fi
	
	# Copy some backgrounds free of use from unsplash <https://unsplash.com> 
	cd "${BASEDIR}"
	cp backgrounds/*.jpg /usr/share/backgrounds
	
	# Copy GTK greeter.conf file
	cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
	
	echo
}

configure_lightdm_greeter 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
