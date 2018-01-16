#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

configure_php_in_userdir(){
	cd "${BASEDIR}"
	
	echo 'Allowing PHP in userdir ...'
	apt-get install -y apache2 libapache2-mod-php7.0 php php-mbstring php-xml
	a2enmod userdir
	backup_file rename '/etc/apache2/mods-available/php7.0.conf'
	cp './apache2-php7.0.conf' '/etc/apache2/mods-available/php7.0.conf'
	systemctl restart apache2
}

cd "${BASEDIR}"
configure_php_in_userdir 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
