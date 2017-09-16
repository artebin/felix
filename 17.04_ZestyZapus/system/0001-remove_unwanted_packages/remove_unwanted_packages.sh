#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

process_package_remove_list(){
  cd ${BASEDIR}
  xargs apt-get -y remove < ./packages.desktop.remove.list
}

cd ${BASEDIR}
process_package_remove_list 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
