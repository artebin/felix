#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

install_remarquable(){
  cd ${BASEDIR}
  wget https://remarkableapp.github.io/files/remarkable_1.87_all.deb
  dpkg -i remarkable_1.87_all.deb
  rm -f remarkable_1.87_all.deb
}

cd ${BASEDIR}
install_remarquable 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
