#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

configure_alternatives(){
  cd ${BASEDIR}
  echo "Setting mate-terminal as x-terminal-emulator ..."
  update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
  echo "Setting firefox as x-www-browser ..."
  update-alternatives --set x-www-browser /usr/bin/firefox
}

cd ${BASEDIR}
configure_alternatives 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
