#!/bin/bash

. ../../common.sh
check_shell

configure_openbox(){
  cd ${BASEDIR}
  echo "Configuring openbox ..."
  renameFileForBackup ~/.config/openbox
  cp -r ./openbox ~/.config/
}

cd ${BASEDIR}
configure_openbox 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
