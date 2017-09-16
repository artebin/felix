#!/bin/bash

. ../../common.sh
check_shell

configure_xfce4_thunar(){
  cd ${BASEDIR}
  echo "Configuring xfce4-thunar ..."
  renameFileForBackup ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
  cp ./thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
}

cd ${BASEDIR}
configure_xfce4_thunar 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
