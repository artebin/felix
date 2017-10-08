#!/bin/bash

source ../../common.sh
check_shell

configure_vlc(){
  cd ${BASEDIR}
  echo "Configuring vlc ..."
  
  renameFileForBackup ~/.config/vlc
  if [ ! -f ~/.config/vlc ]; then
    mkdir -p ~/.config/vlc
  fi
  cp ./vlc-qt-interface.conf ~/.config/vlc
  cp ./vlcrc ~/.config/vlc
  
  renameFileForBackup ~/.local/share/vlc
  if [ ! -f ~/.local/share/vlc ]; then
    mkdir -p ~/.local/share/vlc
  fi
  cp ./ml.xspf ~/.local/share/vlc
}

cd ${BASEDIR}
configure_vlc 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
