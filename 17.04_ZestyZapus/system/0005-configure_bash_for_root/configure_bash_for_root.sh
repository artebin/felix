#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

configure_bash_for_root(){
  cd ${BASEDIR}
  echo "Configuring bash for root ..."
  renameFileForBackup /root/.bashrc
  cp ./bashrc /root/.bashrc
}

cd ${BASEDIR}
configure_bash_for_root 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
