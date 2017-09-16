#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

install_mate_1_17(){
  cd ${BASEDIR}
  add-apt-repository ppa:jonathonf/mate-1.17
  apt-get update
  apt-get upgrade
}

cd ${BASEDIR}
install_mate_1_17 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
