#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

install_skype(){
  cd ${BASEDIR}
  dpkg --add-architecture i386
  add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
  apt-get update 
  apt-get install skype -y
}

cd ${BASEDIR}
install_skype 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
