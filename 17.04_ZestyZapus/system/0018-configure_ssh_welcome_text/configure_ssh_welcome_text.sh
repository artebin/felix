#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

configure_ssh_welcome_text(){
  cd ${BASEDIR}
  cp ./00-welcome-dude /etc/update-motd.d/
  cd ./tux /etc/update-motd.d/
  cd /etc/update-motd.d
  chmod 755 00-welcome-dude
  chmod 100 tux
  chmod a-x 00-header
  chmod a-x 10-help-text
}

cd ${BASEDIR}
configure_ssh_welcome_text 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
