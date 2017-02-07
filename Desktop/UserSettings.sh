#!/bin/sh

. ../common.sh

GTK_ICON_THEME_NAME="Faenza-Bunzen"
GTK_THEME_NAME="Greybird"

configure_bash(){
  echo "Configuring bash ..."
  cd ${BASEDIR}/bash
  renameFileForBackup ~/.bashrc
  cp bashrc ~/.bashrc
}

configure_vim(){
  echo "Configuring vim ..."
  cd ${BASEDIR}/vim
  renameFileForBackup ~/.vimrc
  cp vimrc ~/.vimrc
}

copy_additional_fonts(){
  echo "Copying additonal fonts ..."
  cd ${BASEDIR}/fonts
  sudo cp *.ttf /usr/local/share/fonts/
  echo "Updating font cache ..."
  sudo fc-cache -f -v 1>/dev/null
}

configure_openbox(){
  echo "Configuring openbox ..."
  cd ${BASEDIR}
  renameFileForBackup ~/.config/openbox
  cp -r ./openbox ~/.config/
}

configure_tint2(){
  echo "Configuring tint2 ..."
  cd ${BASEDIR}
  renameFileForBackup ~/.config/tint2
  cp -r ./tint2 ~/.config/
}

configure_dmenu(){
  echo "Configuring dmenu ..."
  cd ${BASEDIR}
  renameFileForBackup ~/.config/dmenu
  cp -r ./dmenu ~/.config/
  chmod +x ~/.config/dmenu/dmenu-bind.sh
}

configure_htop(){
  echo "Configuring htop ..."
  cd ${BASEDIR}/htop
  renameFileForBackup ~/.htoprc
  cp htoprc ~/.htoprc
}

configure_mate_caja(){
  echo "Configuring mate-caja ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/caja/ < org.mate.caja.dump
}

configure_mate_terminal(){
  echo "Configuring mate-terminal ..."
  cd ${BASEDIR}/dconf
  dconf load /org/mate/terminal/ < org.mate.terminal.dump
}

configure_xfce4_thunar(){
  echo "Configuring xfce4-thunar ..."
  cd ${BASEDIR}/xfce4
  renameFileForBackup ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
  cp thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
}

configure_xfce4_power_manager(){
  echo "Configuring xfce4-power-manager ..."
  xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1
}

copy_themes(){
  echo "Copying themes ..."
  cd ${BASEDIR}/themes
  unzip -q Themes-master.zip
  for i in Themes-master/*; do if [ -d "$i" ]; then mv "$i" ~/.themes/; fi; done
  rm -fr ./Themes-master
  tar xzf Erthe-njames.tar.gz
  mv Erthe-njames ~/.themes
}

configure_gtk(){
  echo "Configuring GTK+ ..."
  cd ${BASEDIR}/themes
  
  # GTK+ 2.0
  if [ -f ~/.gtkrc-2.0  ]; then
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" ~/.gtkrc-2.0
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" ~/.gtkrc-2.0
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
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
  fi
  renameFileForBackup ~/.config/gtk-3.0/gtk.css
  cp gtk.css ~/.config/gtk-3.0/gtk.css
}

configure_default_applications(){
  echo "Configuring mate-caja as default file browser ..."
  mkdir -p ~/.local/share/applications
  xdg-mime default caja.desktop inode/directory
}

LOGFILE="UserSettings.StdOutErr.log"
renameFileForBackup ${LOGFILE}

configure_bash 2>&1 | tee -a ${LOGFILE}
configure_vim 2>&1 | tee -a ${LOGFILE}
copy_additional_fonts 2>&1 | tee -a ${LOGFILE}
configure_openbox 2>&1 | tee -a ${LOGFILE}
configure_tint2 2>&1 | tee -a ${LOGFILE}
configure_dmenu 2>&1 | tee -a ${LOGFILE}
configure_htop 2>&1 | tee -a ${LOGFILE}
configure_mate_caja 2>&1 | tee -a ${LOGFILE}
configure_mate_terminal 2>&1 | tee -a ${LOGFILE}
configure_xfce4_thunar 2>&1 | tee -a ${LOGFILE}
configure_xfce4_power_manager 2>&1 | tee -a ${LOGFILE}
copy_themes 2>&1 | tee -a ${LOGFILE}
configure_gtk 2>&1 | tee -a ${LOGFILE}
configure_default_applications 2>&1 | tee -a ${LOGFILE}
