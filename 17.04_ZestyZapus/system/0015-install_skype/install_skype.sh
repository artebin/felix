#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

install_skype(){
  cd ${BASEDIR}
  wget https://go.skype.com/skypeforlinux-64.deb
  dpkg -i skypeforlinux-64.deb
}

cd ${BASEDIR}
install_skype 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
