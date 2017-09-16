#!/bin/bash

. ../../common.sh
check_shell

configure_default_applications(){
  cd ${BASEDIR}
  echo "Configuring mate-caja as default file browser ..."
  mkdir -p ~/.local/share/applications
  xdg-mime default caja.desktop inode/directory
}

cd ${BASEDIR}
configure_default_applications 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
