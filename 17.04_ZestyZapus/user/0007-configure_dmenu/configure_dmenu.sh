#!/bin/bash

source ../../common.sh
check_shell

configure_dmenu(){
  cd ${BASEDIR}
  echo "Configuring dmenu ..."
  renameFileForBackup ~/.config/dmenu
  if [ ! -f ~/.config/dmenu ]; then
    mkdir -p ~/.config/dmenu
  fi
  cp ./dmenu-bind.sh ~/.config/dmenu
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

cd ${BASEDIR}
configure_dmenu 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
