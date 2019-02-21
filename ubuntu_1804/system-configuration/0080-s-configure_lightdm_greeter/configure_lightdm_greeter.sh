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

configure_lightdm_greeter(){
	echo "Configuring LightDM greeter ..."
	
	if [[ -f /etc/lightdm/lightdm-gtk-greeter.conf ]]; then
		backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	fi
	
	# Copy some backgrounds free of use from unsplash <https://unsplash.com> 
	cd "${RECIPE_DIR}"
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
