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

enable_hibernation(){
	echo "Enable hibernation ..."
	
	# Add polkit authority for upower and logind
	cd "${RECIPE_DIR}"
	cp com.ubuntu.enable-hibernate.pkla /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
	
	echo
}

configure_suspend_then_hibernation(){
	echo "Configuring suspend-then-hibernation ..."
	
	# Add or create file /etc/systemd/sleep.conf
	if [[ ! -f /etc/systemd/sleep.conf ]]; then
		cp sleep.conf /etc/systemd/sleep.conf
	else
		add_or_update_keyvalue /etc/systemd/sleep.conf "HibernateDelaySec" "300"
	fi
	
	# Configure logind
	echo "Set HandleLidSwitch=suspend ..."
	add_or_update_line_based_on_prefix '#*HandleLidSwitch=' 'HandleLidSwitch=suspend-then-hibernate' /etc/systemd/logind.conf
	
	# Restart the service
	systemctl restart systemd-logind.service
	
	echo
}

enable_hibernation 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

configure_suspend_then_hibernation 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
