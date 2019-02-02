#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_php_in_userdir(){
	cd ${BASEDIR}
	
	echo "Allowing PHP in userdir ..."
	apt-get install -y apache2 libapache2-mod-php php php-mbstring php-xml
	a2enmod userdir
	
	backup_file rename /etc/apache2/mods-available/php7.2.conf
	cp ./apache2-php7.2.conf /etc/apache2/mods-available/php7.2.conf
	
	systemctl restart apache2
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_php_in_userdir 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
