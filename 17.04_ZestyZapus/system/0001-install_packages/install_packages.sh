#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

process_package_install_list(){
  cd ${BASEDIR}
  xargs apt-get -y install < ./packages.desktop.install.list
}

cd ${BASEDIR}
process_package_install_list 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
