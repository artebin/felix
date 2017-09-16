#!/bin/bash

. ../../common.sh
check_shell

configure_bash(){
  cd ${BASEDIR}
  echo "Configuring bash ..."
  renameFileForBackup ~/.bashrc
  cp ./bashrc ~/.bashrc
}

cd ${BASEDIR}
configure_bash  2>&1 | tee -a ./${SCRIPT_LOG_NAME}
