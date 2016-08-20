#!/bin/sh

. ./common.sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME=openbox_badge-symbolic#1.svg

disable_apport(){
  echo "Disabling apport ..."
  sudo sed -i '/^enabled=/s/.*/enabled=0/' /etc/default/apport
}

add_lightdm_greeter_badges(){
  echo "Adding lighdm greeter badges ..."
  # Greeter badge for Openbox
  cd ${BASEDIR}/lightdm-greeter-badge
  sudo cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  sudo gtk-update-icon-cache /usr/share/icons/hicolor
}

configure_alternatives(){
  echo "Setting mate-terminal as default x-terminal-emulator ..."
  sudo update_alternatives set x-terminal-emulator /usr/bin/mate-terminal.wrapper
}

copy_themes(){
  echo "Copying themes ..."
  cd ${BASEDIR}/themes
  tar xzf Erthe-njames.tar.gz
  sudo cp -R Erthe-njames /usr/share/themes
  sudo chmod -R 755 /usr/share/themes
  rm -fr Erthe-njames
}

configure_gtk(){
  echo "Configuring gtk ..."
  cd ${BASEDIR}/themes

  # GTK+ 2.0
  if [ -f /etc/gtk-2.0/gtkrc  ]; then
    sudo sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=\"Greybird\"/' /etc/gtk-2.0/gtkrc
    sudo sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' /etc/gtk-2.0/gtkrc
  else
    sudo cp system.gtkrc-2.0 /etc/gtk-2.0/gtkrc
    sudo chmod 755 /etc/gtk-2.0/gtkrc
  fi

  # GTK+ 3.0
  if [ -f /etc/gtk-3.0/settings.ini ]; then
    sudo sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=Greybird/' /etc/gtk-3.0/settings.ini
    sudo sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' /etc/gtk-3.0/settings.ini
  else
    sudo cp system.gtkrc-3.0 /etc/gtk-3.0/settings.ini
    sudo chmod 755 /etc/gtk-3.0/settings.ini
  fi

  # Disable the scrollbar overlay introduced in GTK+ 3.15
  # Cannot find a property in gtkrc-3.0 for that...
  echo "export GTK_OVERLAY_SCROLLING=0" | sudo tee /etc/X11/Xsession.d/80gtk-overlay-scrolling

  # Disable SWT_GTK3 (use GTK+ 2.0 for SWT)
  echo "export SWT_GTK3=0" | sudo tee /etc/X11/Xsession.d/80swt-gtk
}

configure_grub(){
  echo "Configuring grub ..."
  # Remove hidden timeout 0 => show grub
  sudo sed -i '/^GRUB_HIDDEN_TIMEOUT/s/.*/#GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
  # Remove boot option "quiet" and "splash"
  sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
  sudo update-grub
}

configure_bash_for_root(){
  echo "Configuring bash for root ..."
  cd ${BASEDIR}/bash
  sudo renameFileForBackup /root/.bashrc
  sudo cp bashrc /root/.bashrc
}

disable_apport
add_lightdm_greeter_badges
copy_themes
configure_gtk
configure_grub
configure_bash_for_root
