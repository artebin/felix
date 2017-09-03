#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "Please run with root privileges"
  exit
fi

. ../common.sh


DOKUWIKI_STABLE="dokuwiki-2017-02-19e"
USERNAME=""

system_setup(){
  cd ${BASEDIR}
  apt-get install -y "apache2 libapache2-mod-php7.0 php php-mbstring"
  a2enmod userdir
  renameFileForBackup /etc/apache2/mods-available/php7.0.conf
  cp ./dokuwiki/apache2-php7.0.conf /etc/apache2/mods-available/php7.0.conf
  systemctl restart apache2
}

user_setup(){
  adduser www-data ${USERNAME}
  mkdir -p ~/public_html
  cp ./dokuwiki/dokuwiki-stable.tgz ~/public_html
  cd ~/public_html
  tar xzf dokuwiki-stable.tgz
  cd ${BASEDIR}
  cp ./dokuwiki/dokubook-stable.tgz ~/${DOKUWIKI_STABLE}/lib/tpl/
  cp ./dokuwiki/conf/entities.conf ~/${DOKUWIKI_STABLE}/conf/
  cp ./dokuwiki/conf/userstyle.css ~/${DOKUWIKI_STABLE}/conf/
  chmod -R g+r ~/public_html
  find ~/public_html -type d | xargs chmod g+x
}

system_setup
user_setup
