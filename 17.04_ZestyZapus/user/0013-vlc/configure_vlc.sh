#!/bin/bash

. ../../common.sh
check_shell

configure_vlc(){
  cd ${BASEDIR}
  echo "Configuring vlc ..."
  mkdir -p ~/.config/vlc
  cp ./vlc-qt-interface.conf ~/.config/vlc
  cp ./vlcrc ~/.config/vlc
  mkdir -p ~/.local/share/vlc
  cp ./ml.xspf ~/.local/share/vlc
}

cd ${BASEDIR}
configure_vlc 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
