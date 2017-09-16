#!/bin/bash

. ../../common.sh
check_shell

configure_tint2(){
  cd ${BASEDIR}
  echo "Configuring tint2 ..."
  renameFileForBackup ~/.config/tint2
  cp -r ./tint2 ~/.config/
}

cd ${BASEDIR}
configure_tint2 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
