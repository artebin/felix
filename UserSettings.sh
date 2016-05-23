#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
WALLPAPER_FILE_NAME=pattern_154.gif

renameFileForBackup(){
  SUFFIX=.bak.$(date +"%y%m%d-%H%M%S")
  mv "$1" "$1"${SUFFIX}
}

setupBash(){
  cd ${BASEDIR}/bash
  if [ -f ~/.bashrc ]; then
    renameFileForBackup ~/.bashrc
  fi
  cp bashrc ~/.bashrc
}

setupVim(){
  cd ${BASEDIR}/vim
  if [ -f ~/.vimrc ]; then
    renameFileForBackup ~/.vimrc
  fi
  cp vimrc ~/.vimrc
}

additionalFonts(){
  cd ${BASEDIR}/fonts
  sudo cp *.ttf /usr/local/share/fonts/
  sudo fc-cache -f -v
}

setupOpenbox(){
  cd ${BASEDIR}
  if [ -d ~/.config/openbox ]; then
    renameFileForBackup ~/.config/openbox
  fi
  cp -r ./openbox ~/.config/
}

setupTint2(){
  cd ${BASEDIR}
  if [ -d ~/.config/tint2 ]; then
    renameFileForBackup ~/.config/tint2
  fi
  cp -r ./tint2 ~/.config/
}

setupDmenu(){
  cd ${BASEDIR}
  if [ -d ~/.config/dmenu ]; then
    renameFileForBackup ~/.config/dmenu
  fi
  cp -r ./dmenu ~/.config/
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

setupHtop(){
  cd ${BASEDIR}/htop
  cp htoprc ~/.htoprc
}

setupMateCaja(){
  cd ${BASEDIR}/dconf
  dconf load /org/mate/caja/ < org.mate.caja.dump
}

setupMateTerminal(){
  cd ${BASEDIR}/dconf
  dconf load /org/mate/terminal/ < org.mate.terminal.dump
}

setupXFCE4PowerManager(){
  xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
}

copyOpenboxAndGtkThemes(){
  cd ${BASEDIR}/themes
  unzip -q Themes-master.zip
  for i in Themes-master/*; do if [ -d "$i" ]; then mv "$i" ~/.themes/; fi; done
  rm -fr ./Themes-master
  tar xzf Erthe-njames.tar.gz
  mv Erthe-njames ~/.themes
}

setupGtk(){
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

if [ -f output ]; then
  renameFileForBackup output
fi
setupBash >>output 2>>output
setupVim >>output 2>>output
additionalFonts >>output 2>>output
setupOpenbox >>output 2>>output
setupTint2 >>output 2>>output
setupDmenu >>output 2>>output
setupHtop >>output 2>>output
setupMateCaja >>output 2>>output
setupMateTerminal >>output 2>>output
setupXFCE4PowerManager >>output 2>>output
copyOpenboxAndGtkThemes >>output 2>>output
setupGtk >>output 2>>output
setupWallpaper >>output 2>>output
