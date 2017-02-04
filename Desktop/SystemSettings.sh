#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "Please run with root privileges"
  exit
fi

. ../common.sh

LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME="openbox_badge-symbolic#1.svg"
GTK_ICON_THEME_NAME="Faenza-Bunzen"
GTK_THEME_NAME="Greybird"

disable_apport(){
  echo "Disabling apport ..."
  sed -i '/^enabled=/s/.*/enabled=0/' /etc/default/apport
}

add_lightdm_greeter_badges(){
  echo "Adding lighdm greeter badges ..."
  cd ${BASEDIR}/lightdm-greeter-badge
  cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  update-icon-cache /usr/share/icons/hicolor
}

configure_alternatives(){
  echo "Setting mate-terminal as x-terminal-emulator ..."
  update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
  echo "Setting firefox as x-www-browser ..."
  update-alternatives --set x-www-browser /usr/bin/firefox
}

copy_themes(){
  echo "Copying themes ..."
  cd ${BASEDIR}/themes
  tar xzf Erthe-njames.tar.gz
  cp -R Erthe-njames /usr/share/themes
  cd /usr/share/themes
  chmod -R go+r ./Erthe-njames
  find ./Erthe-njames -type d | xargs chmod go+x
  cd ${BASEDIR}/themes
  rm -fr Erthe-njames
}

install_bunsen_faenza(){
  echo "Installing bunsen-faenza-icon-theme ..."
  cd ${BASEDIR}/themes
  git clone https://github.com/BunsenLabs/bunsen-faenza-icon-theme
  cd bunsen-faenza-icon-theme
  tar xzf bunsen-faenza-icon-theme.tar.gz
  cp -r ./Faenza-Bunsen /usr/share/icons/
  cp -r ./Faenza-Bunsen-common /usr/share/icons
  cp -r ./Faenza-Dark-Bunsen /usr/share/icons
  update-icons-cache /usr/share/icons
  cd ${BASEDIR}/themes
  rm -fr bunsen-faenza-icon-theme
}

configure_gtk(){
  echo "Configuring GTK+ ..."
  cd ${BASEDIR}/themes

  # GTK+ 2.0
  if [ -f /etc/gtk-2.0/gtkrc  ]; then
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
  else
    cp system.gtkrc-2.0 /etc/gtk-2.0/gtkrc
    chmod 755 /etc/gtk-2.0/gtkrc
  fi

  # GTK+ 3.0
  if [ -f /etc/gtk-3.0/settings.ini ]; then
    sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
    sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini
  else
    cp system.gtkrc-3.0 /etc/gtk-3.0/settings.ini
    chmod 755 /etc/gtk-3.0/settings.ini
  fi

  # Disable the scrollbar overlay introduced in GTK+ 3.16
  # Cannot find a property in gtkrc-3.0 for that...
  echo "GTK_OVERLAY_SCROLLING=0" | sudo tee -a /etc/environment
  # Disable SWT_GTK3 (use GTK+ 2.0 for SWT)
  echo "SWT_GTK3=0" | sudo tee -a /etc/environment
  
  # It would be better to put the 2 env. variables above in Xsession.d as it will be less likely to conflict 
  # with updates made by the packaging system but root could not have them.
  #echo "export GTK_OVERLAY_SCROLLING=0" | sudo tee /etc/X11/Xsession.d/80gtk-overlay-scrolling
  #echo "export SWT_GTK3=0" | sudo tee /etc/X11/Xsession.d/80swt-gtk

  # Add gtk.css for root
  cd ${BASEDIR}/themes
  mkdir -p /root/.config/gtk-3.0
  cp gtk.css /root/.config/gtk-3.0/gtk.css
}

configure_grub(){
  echo "Configuring grub ..."
  # Remove hidden timeout 0 => show grub
  sed -i '/^GRUB_HIDDEN_TIMEOUT/s/.*/#GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
  # Remove boot option "quiet" and "splash"
  sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
  update-grub
}

configure_bash_for_root(){
  echo "Configuring bash for root ..."
  cd ${BASEDIR}/bash
  renameFileForBackup /root/.bashrc
  cp bashrc /root/.bashrc
}

enable_hibernation(){
  echo "Enabling hibernation ..."
  cd ${BASEDIR}
  cat com.ubuntu.enable-hibernate.pkla | sudo tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
}

disable_apport
add_lightdm_greeter_badges
configure_alternatives
copy_themes
install_bunzen_faenza
configure_gtk
configure_grub
configure_bash_for_root
enable_hibernation
