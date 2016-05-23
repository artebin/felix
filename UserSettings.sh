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

setupBash(){
  echo "Configuring bash ..."
  cd ${BASEDIR}/bash
  if [ -f ~/.bashrc ]; then
    renameFileForBackup ~/.bashrc
  fi
  cp bashrc ~/.bashrc
}

setupVim(){
  echo "Configuring vim ..."
  cd ${BASEDIR}/vim
  if [ -f ~/.vimrc ]; then
    renameFileForBackup ~/.vimrc
  fi
  cp vimrc ~/.vimrc
}

additionalFonts(){
  echo "Copying fonts ..."
  cd ${BASEDIR}/fonts
  sudo cp *.ttf /usr/local/share/fonts/
  echo "Updating font cache ..."
  sudo fc-cache -f -v 1>/dev/null
}

setupOpenbox(){
  echo "Configuration openbox ..."
  cd ${BASEDIR}
  if [ -d ~/.config/openbox ]; then
    renameFileForBackup ~/.config/openbox
  fi
  cp -r ./openbox ~/.config/
}

setupTint2(){
  echo "Configuration tint2 ..."
  cd ${BASEDIR}
  if [ -d ~/.config/tint2 ]; then
    renameFileForBackup ~/.config/tint2
  fi
  cp -r ./tint2 ~/.config/
}

setupDmenu(){
  echo "Configuration dmenu ..."
  cd ${BASEDIR}
  if [ -d ~/.config/dmenu ]; then
    renameFileForBackup ~/.config/dmenu
  fi
  cp -r ./dmenu ~/.config/
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

setupHtop(){
  echo "Configuration htop ..."
  cd ${BASEDIR}/htop
  cp htoprc ~/.htoprc
}

setupMateCaja(){
  echo "Configuration MATE Caja ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/caja/ < org.mate.caja.dump
}

setupMateTerminal(){
  echo "Configuring MATE Terminal ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/terminal/ < org.mate.terminal.dump
}

setupXFCE4PowerManager(){
  echo "Configuring XFCE4-Power-Manager ..."
  xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
}

copyOpenboxAndGtkThemes(){
  echo "Copy Openbox and Gtk themes ..."
  cd ${BASEDIR}/themes
  unzip -q Themes-master.zip
  for i in Themes-master/*; do if [ -d "$i" ]; then mv "$i" ~/.themes/; fi; done
  rm -fr ./Themes-master
  tar xzf Erthe-njames.tar.gz
  mv Erthe-njames ~/.themes
}

setupGtk(){
  echo "Configuring Gtk ..."
  cd ${BASEDIR}/themes
  if [ -f ~/.gtkrc-2.0  ]; then
    sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=\"Greybird\"/' ~/.gtkrc-2.0
    sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' ~/.gtkrc-2.0
  else
    cp gtkrc-2.0 ~/.gtkrc-2.0
  fi
  if [ -d ~/.config/gtk-3.0 ]; then  
    if [ -f ~/.config/gtk-3.0/settings.ini ]; then
      sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=Greybird/' ~/.config/gtk-3.0/settings.ini
      sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' ~/.gtkrc-2.0
    else
      cp gtkrc-3.0 ~/.config/gtk-3.0/settings.ini
    fi
  else
    mkdir ~/.config/gtk-3.0
    cp gtkrc-3.0 ~/.config/gtk-3.0/settings.ini
  fi
}

setupWallpaper(){
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
setupBash 2>&1 | tee -a StdOutErr.log
setupVim 2>&1 | tee -a StdOutErr.log
additionalFonts 2>&1 | tee -a StdOutErr.log
setupOpenbox 2>&1 | tee -a StdOutErr.log
setupTint2 2>&1 | tee -a StdOutErr.log
setupDmenu 2>&1 | tee -a StdOutErr.log
setupHtop 2>&1 | tee -a StdOutErr.log
setupMateCaja 2>&1 | tee -a StdOutErr.log
setupMateTerminal 2>&1 | tee -a StdOutErr.log
setupXFCE4PowerManager 2>&1 | tee -a StdOutErr.log
copyOpenboxAndGtkThemes 2>&1 | tee -a StdOutErr.log
setupGtk 2>&1 | tee -a StdOutErr.log
setupWallpaper 2>&1 | tee -a StdOutErr.log
