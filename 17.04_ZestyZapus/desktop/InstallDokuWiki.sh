#!/bin/sh

if [ $(id -u) -eq 0 ]; then
  echo "This script must not be run with root privileges!"
  exit 1
fi

. ../common.sh

DOKUWIKI_STABLE="dokuwiki-2017-02-19e"
USERNAME=`whoami`

system_setup(){
  cd ${BASEDIR}
  sudo apt-get install -y "apache2 libapache2-mod-php7.0 php php-mbstring"
  sudo a2enmod userdir
  sudo renameFileForBackup /etc/apache2/mods-available/php7.0.conf
  sudo cp ./dokuwiki/apache2-php7.0.conf /etc/apache2/mods-available/php7.0.conf
  sudo systemctl restart apache2
}

user_setup(){
  cd ${BASEDIR}
  sudo adduser www-data ${USERNAME}
  mkdir -p ~/public_html
  cp ./dokuwiki/dokuwiki-stable.tgz ~/public_html
  cd ~/public_html
  tar xzf dokuwiki-stable.tgz
  cd ${BASEDIR}
  cp ./dokuwiki/dokubook-stable.tgz ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/
  cp ./dokuwiki/conf/entities.conf ~/public_html/${DOKUWIKI_STABLE}/conf/
  cp ./dokuwiki/conf/userstyle.css ~/public_html/${DOKUWIKI_STABLE}/conf/
  cd ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/
  tar xzf dokubook-stable.tgz
  chmod -R g+r ~/public_html
  find ~/public_html -type d | xargs chmod g+x
}

system_setup
user_setup
x-www-browser http://localhost/~${USERNAME}/${DOKUWIKI_STABLE}/install.php
