#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
WALLPAPER_FILE_NAME=pattern_154.gif

getFileNameForBackup(){
  SUFFIX=${1}.bak.$(date +"%y%m%d-%H%M%S")
  echo ${SUFFIX}
}

renameFileForBackup(){
  BACKUP_FILE=$(getFileNameForBackup "$1")
  echo "Renamed existing file ${1} to ${BACKUP_FILE}"
  mv "$1" ${BACKUP_FILE}
}

configure_bash(){
  echo "Configuring bash ..."
  cd ${BASEDIR}/bash
  if [ -f ~/.bashrc ]; then
    renameFileForBackup ~/.bashrc
  fi
  cp bashrc ~/.bashrc
}

configure_vim(){
  echo "Configuring vim ..."
  cd ${BASEDIR}/vim
  if [ -f ~/.vimrc ]; then
    renameFileForBackup ~/.vimrc
  fi
  cp vimrc ~/.vimrc
}

copy_additional_fonts(){
  echo "Copying fonts ..."
  cd ${BASEDIR}/fonts
  sudo cp *.ttf /usr/local/share/fonts/
  echo "Updating font cache ..."
  sudo fc-cache -f -v 1>/dev/null
}

configure_openbox(){
  echo "Configuration openbox ..."
  cd ${BASEDIR}
  if [ -d ~/.config/openbox ]; then
    renameFileForBackup ~/.config/openbox
  fi
  cp -r ./openbox ~/.config/
}

configure_tint2(){
  echo "Configuration tint2 ..."
  cd ${BASEDIR}
  if [ -d ~/.config/tint2 ]; then
    renameFileForBackup ~/.config/tint2
  fi
  cp -r ./tint2 ~/.config/
}

configure_dmenu(){
  echo "Configuration dmenu ..."
  cd ${BASEDIR}
  if [ -d ~/.config/dmenu ]; then
    renameFileForBackup ~/.config/dmenu
  fi
  cp -r ./dmenu ~/.config/
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

configure_htop(){
  echo "Configuration htop ..."
  cd ${BASEDIR}/htop
  cp htoprc ~/.htoprc
}

configure_mate_caja(){
  echo "Configuration MATE Caja ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/caja/ < org.mate.caja.dump
}

configure_mate_terminal(){
  echo "Configuring MATE Terminal ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/terminal/ < org.mate.terminal.dump
}

configure_xfce4_power_manager(){
  echo "Configuring XFCE4-Power-Manager ..."
  xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
}

copy_themes(){
  echo "Copy Openbox and Gtk themes ..."
  cd ${BASEDIR}/themes
  unzip -q Themes-master.zip
  for i in Themes-master/*; do if [ -d "$i" ]; then mv "$i" ~/.themes/; fi; done
  rm -fr ./Themes-master
  tar xzf Erthe-njames.tar.gz
  mv Erthe-njames ~/.themes
}

configure_gtk(){
  cd ${BASEDIR}/themes
  
  # GTK+ 2.0
  if [ -f ~/.gtkrc-2.0  ]; then
    sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=\"Greybird\"/' ~/.gtkrc-2.0
    sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' ~/.gtkrc-2.0
  else
    cp user.gtkrc-2.0 ~/.gtkrc-2.0
  fi

  # GTK+ 3.0
  if [ ! -d ~/.config/gtk-3.0 ]; then
    mkdir ~/.config/gtk-3.0
  fi
  if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
    cp user.gtkrc-3.0 ~/.config/gtk-3.0/settings.ini
  else
    sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=Greybird/' ~/.config/gtk-3.0/settings.ini
    sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' ~/.config/gtk-3.0/settings.ini
  fi
}

set_wallpaper(){
  echo "Setting wallpaper ..."
  cp ${BASEDIR}/pictures/${WALLPAPER_FILE_NAME} ~/Pictures
  cd ${BASEDIR}/nitrogen
  if [ ! -d ~/.config/nitrogen ]; then
    mkdir ~/.config/nitrogen
  fi
  if [ ! -f ~/.config/nitrogen/bg-saved.cfg ]; then
    cp bg-saved.cfg ~/.config/nitrogen
  fi
  ESCHAPED_PATH=$(echo ${HOME}/Pictures/${WALLPAPER_FILE_NAME} | sed 's/\//\\\//g')
  sed -i "/^file=/s/.*/file=${ESCHAPED_PATH}/" ~/.config/nitrogen/bg-saved.cfg
  nitrogen --restore	
}

if [ -f StdOutErr.log ]; then
  renameFileForBackup StdOutErr.log
fi

configure_bash 2>&1 | tee -a StdOutErr.log
configure_vim 2>&1 | tee -a StdOutErr.log
copy_additional_fonts 2>&1 | tee -a StdOutErr.log
configure_openbox 2>&1 | tee -a StdOutErr.log
configure_tint2 2>&1 | tee -a StdOutErr.log
configure_dmenu 2>&1 | tee -a StdOutErr.log
configure_htop 2>&1 | tee -a StdOutErr.log
configure_mate_caja 2>&1 | tee -a StdOutErr.log
configure_mate_terminal 2>&1 | tee -a StdOutErr.log
configure_xfce4_power_manager 2>&1 | tee -a StdOutErr.log
copy_themes 2>&1 | tee -a StdOutErr.log
configure_gtk 2>&1 | tee -a StdOutErr.log
set_wallpaper 2>&1 | tee -a StdOutErr.log
