#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

upgrade_system(){
  cd ${BASEDIR}
  apt-get update
  apt-get -y upgrade
}

cd ${BASEDIR}
upgrade_system 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
