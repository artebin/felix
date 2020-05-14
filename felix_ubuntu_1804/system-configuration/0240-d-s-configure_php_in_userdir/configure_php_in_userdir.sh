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

configure_php_in_userdir(){
	echo "Allowing PHP in userdir ..."
	
	echo "Installing apache2 and php ..."
	install_package_if_not_installed "apache2" "libapache2-mod-php" "php" "php-mbstring" "php-xml"
	
	echo "Enabling userdir module ..."
	a2enmod userdir
	
	echo "Edit PHP configuration files ..."
	cd "${RECIPE_DIRECTORY}"
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

cd "${RECIPE_DIRECTORY}"
configure_php_in_userdir 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
