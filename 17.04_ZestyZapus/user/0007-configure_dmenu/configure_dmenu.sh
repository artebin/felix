#!/bin/bash

. ../../common.sh
check_shell

configure_dmenu(){
  cd ${BASEDIR}
  echo "Configuring dmenu ..."
  renameFileForBackup ~/.config/dmenu
  cp -r ./dmenu ~/.config/
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

cd ${BASEDIR}
configure_dmenu 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
