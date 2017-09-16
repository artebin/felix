#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

configure_php_in_userdir(){
  cd ${BASEDIR}
  apt-get install -y "apache2 libapache2-mod-php7.0 php php-mbstring"
  a2enmod userdir
  renameFileForBackup /etc/apache2/mods-available/php7.0.conf
  cp ./dokuwiki/apache2-php7.0.conf /etc/apache2/mods-available/php7.0.conf
  systemctl restart apache2
}

cd ${BASEDIR}
configure_php_in_userdir 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
