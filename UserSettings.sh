#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

renameFileForBackup(){
  SUFFIX=.bak.$(date +"%y%m%d-%H%M%S")
  mv "$1" "$1"${SUFFIX}
}

# bash
cd ${BASEDIR}/bash
if [ -f ~/.bashrc ]; then
  renameFileForBackup ~/.bashrc
fi
cp bashrc ~/.bashrc

# lightdm greeter openbox badge
cd ${BASEDIR}/lightdm-greeter-badge
sudo cp openbox_badge-symbolic#1.svg /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
sudo gtk-update-icon-cache /usr/share/icons/hicolor

# some additional fonts
cd ${BASEDIR}/fonts
sudo cp *.ttf /usr/local/share/fonts/
sudo fc-cache -f -v

# openbox
cd ${BASEDIR}
if [ -d ~/.config/openbox ]; then
  renameFileForBackup ~/.config/openbox
fi
cp -r ./openbox ~/.config/

# tint2
cd ${BASEDIR}
if [ -d ~/.config/tint2 ]; then
  renameFileForBackup ~/.config/tint2
fi
cp -r ./tint2 ~/.config/

# dmenu
cd ${BASEDIR}
if [ -d ~/.config/dmenu ]; then
  renameFileForBackup ~/.config/dmenu
fi
cp -r ./dmenu ~/.config/
chmod +x ~/.config/dmenu/dmenu-bind.sh

# htop
cd ${BASEDIR}/htop
cp htoprc ~/.htoprc

# mate caja
cd ${BASEDIR}/dconf
dconf load /org/mate/caja/ < org.mate.caja.dump

# mate terminal
cd ${BASEDIR}/dconf
dconf load /org/mate/terminal/ < org.mate.terminal.dump

# Show xfce4-power-manager icon tray
xfconf-query --create -t int -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 1

# themes
cd ${BASEDIR}/themes
unzip -q Themes-master.zip
for i in Themes-master/*; do if [ -d "$i" ]; then mv "$i" ~/.themes/; fi; done
rm -fr ./Themes-master
tar xzf Erthe-njames.tar.gz
mv Erthe-njames ~/.themes

# gtk widget theme and icon theme
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

# wallpapers
WALLPAPER_FILE_NAME=pattern_154.gif
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
