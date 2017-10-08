#!/bin/bash

source ../../common.sh
check_shell

DOKUWIKI_STABLE="dokuwiki-2017-02-19e"
USERNAME=`whoami`

install_dokuwiki_in_userdir(){
  cd ${BASEDIR}
  sudo adduser www-data ${USERNAME}
  
  cd ${BASEDIR}
  mkdir -p ~/public_html
  cp ./dokuwiki-stable.tgz ~/public_html
  cd ~/public_html
  tar xzf dokuwiki-stable.tgz
  
  cd ${BASEDIR}
  cp ./dokubook-stable.tgz ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/
  cp ./conf/entities.conf ~/public_html/${DOKUWIKI_STABLE}/conf/
  cp ./conf/userstyle.css ~/public_html/${DOKUWIKI_STABLE}/conf/
  cd ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/
  tar xzf ./dokubook-stable.tgz
  chmod -R g+r ~/public_html
  chmod -R g+w ~/public_html/${DOKUWIKI_STABLE}/data
  find ~/public_html -type d | xargs chmod g+x
}

cd ${BASEDIR}
install_dokuwiki_in_userdir 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
x-www-browser http://localhost/~${USERNAME}/${DOKUWIKI_STABLE}/install.php &
