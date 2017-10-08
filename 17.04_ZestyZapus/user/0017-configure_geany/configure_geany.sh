#!/bin/bash

source ../../common.sh
check_shell

configure_geany(){
  cd ${BASEDIR}
  echo "Configuring geany ..."
  renameFileForBackup ~/.config/geany
  if [ ! -f ~/.config/geany ]; then
    mkdir -p ~/.config/geany
  fi
  cp filetypes.common ~/.config/geany/filetypes.common
}

cd ${BASEDIR}
configure_geany 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
