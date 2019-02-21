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

configure_php_in_userdir(){
	echo "Allowing PHP in userdir ..."
	
	echo "Installing apache2 and php ..."
	install_packages_if_not_installed "apache2" "libapache2-mod-php" "php" "php-mbstring" "php-xml"
	
	echo "Enabling userdir module ..."
	a2enmod userdir
	
	echo "Edit PHP configuration files ..."
	cd "${RECIPE_DIR}"
	if [[ ! -f /etc/apache2/mods-available/php7.2.conf ]]; then
		echo "Cannot find PHP configuration file: /etc/apache2/mods-available/php7.2.conf"
		return 1
	fi
	backup_file rename /etc/apache2/mods-available/php7.2.conf
	cp apache2-php7.2.conf /etc/apache2/mods-available/php7.2.conf
	
	echo "Restarting apache2 ..."
	systemctl restart apache2
	
	echo
}

cd "${RECIPE_DIR}"
configure_php_in_userdir 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
