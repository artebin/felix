#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "Please run with root privileges"
  exit
fi

. ./common.sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME=openbox_badge-symbolic#1.svg

disable_apport(){
  echo "Disabling apport ..."
  sed -i '/^enabled=/s/.*/enabled=0/' /etc/default/apport
}

add_lightdm_greeter_badges(){
  echo "Adding lighdm greeter badges ..."
  # Greeter badge for Openbox
  cd ${BASEDIR}/lightdm-greeter-badge
  cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  gtk-update-icon-cache /usr/share/icons/hicolor
}

configure_alternatives(){
  echo "Setting mate-terminal as default x-terminal-emulator ..."
  update_alternatives set x-terminal-emulator /usr/bin/mate-terminal.wrapper
}

copy_themes(){
  echo "Copying themes ..."
  cd ${BASEDIR}/themes
  tar xzf Erthe-njames.tar.gz
  cp -R Erthe-njames /usr/share/themes
  chmod -R 755 /usr/share/themes/Erthe-njames
  rm -fr Erthe-njames
}

configure_gtk(){
  echo "Configuring gtk ..."
  cd ${BASEDIR}/themes

  # GTK+ 2.0
  if [ -f /etc/gtk-2.0/gtkrc  ]; then
    sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=\"Greybird\"/' /etc/gtk-2.0/gtkrc
    sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' /etc/gtk-2.0/gtkrc
  else
    cp system.gtkrc-2.0 /etc/gtk-2.0/gtkrc
    chmod 755 /etc/gtk-2.0/gtkrc
  fi

  # GTK+ 3.0
  if [ -f /etc/gtk-3.0/settings.ini ]; then
    sed -i '/^gtk-theme-name/s/.*/gtk-theme-name=Greybird/' /etc/gtk-3.0/settings.ini
    sed -i '/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"Faenza-Dark\"/' /etc/gtk-3.0/settings.ini
  else
    cp system.gtkrc-3.0 /etc/gtk-3.0/settings.ini
    chmod 755 /etc/gtk-3.0/settings.ini
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

disable_apport
add_lightdm_greeter_badges
copy_themes
configure_gtk
configure_grub
configure_bash_for_root
