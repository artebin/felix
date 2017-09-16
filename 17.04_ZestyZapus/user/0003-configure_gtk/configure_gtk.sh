#!/bin/bash

. ../../common.sh
check_shell

GTK_ICON_THEME_NAME="Faenza-Bunzen"
GTK_THEME_NAME="Greybird"

configure_gtk(){
  cd ${BASEDIR}
  echo "Configuring GTK+ ..."
  
  # GTK+ 2.0
  if [ -f ~/.gtkrc-2.0  ]; then
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" ~/.gtkrc-2.0
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" ~/.gtkrc-2.0
  else
    cp ./user.gtkrc-2.0 ~/.gtkrc-2.0
  fi

  # GTK+ 3.0
  if [ ! -d ~/.config/gtk-3.0 ]; then
    mkdir ~/.config/gtk-3.0
  fi
  if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
    cp ./user.gtkrc-3.0 ~/.config/gtk-3.0/settings.ini
  else
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
  fi
  renameFileForBackup ~/.config/gtk-3.0/gtk.css
  cp ./gtk.css ~/.config/gtk-3.0/gtk.css
}

cd ${BASEDIR}
configure_gtk 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
