#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

enable_hibernation(){
  cd ${BASEDIR}
  echo "Enabling hibernation ..."
  cat ./com.ubuntu.enable-hibernate.pkla | tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
}

cd ${BASEDIR}
enable_hibernation 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
