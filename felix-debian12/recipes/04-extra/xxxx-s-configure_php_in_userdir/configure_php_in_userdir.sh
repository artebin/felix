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

configure_php_in_userdir(){
	printf "Allowing PHP in userdir...\n"
	
	printf "Installing apache2 and php...\n"
	install_package_if_not_installed "apache2" "libapache2-mod-php" "php" "php-mbstring" "php-xml"
	
	printf "Enabling userdir module...\n"
	a2enmod userdir
	
	printf "Edit PHP configuration files...\n"
	cd "${RECIPE_DIRECTORY}"
	if [[ ! -f /etc/apache2/mods-available/php8.2.conf ]]; then
		printf "Cannot find PHP configuration file: /etc/apache2/mods-available/php8.2.conf\n"
		return 1
	fi
	backup_file rename /etc/apache2/mods-available/php8.2.conf
	cp apache2-php8.2.conf /etc/apache2/mods-available/php8.2.conf
	
	printf "Restarting apache2...\n"
	systemctl restart apache2
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
configure_php_in_userdir 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
