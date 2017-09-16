#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

install_pasystray(){
  cd ${BASEDIR}
  git clone http://github.com/christophgysin/pasystray
  cd pasystray
  ./bootstrap.sh
  ./configure
  make
  make install
  
  # Cleanup
  cd ${BASEDIR}
  rm -fr pasystray
}

cd ${BASEDIR}
install_pasystray 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
