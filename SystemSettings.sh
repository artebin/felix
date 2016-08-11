#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME=openbox_badge-symbolic#1.svg

disable_apport(){
  sudo sed -i '/^enabled=/s/.*/enabled=0/' /etc/default/apport
}

add_lightdm_greeter_badges(){
  # Greeter badge for Openbox
  cd ${BASEDIR}/lightdm-greeter-badge
  sudo cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  sudo gtk-update-icon-cache /usr/share/icons/hicolor
}

configure_gtk(){
  cd ${BASEDIR}/themes

  # Copy theme
  tar xzf Erthe-njames.tar.gz
  sudo cp -R Erthe-njames /usr/share/themes
  sudo chmod -R 755 /usr/share/themes
  rm -fr Erthe-njames

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
  echo "export GTK_OVERLAY_SCROLLING=0" | sudo tee /etc/X11/Xsession.d/80overlayscrollbars
}

configure_grub(){
  # Remove hidden timeout 0 => show grub
  sudo sed -i '/^GRUB_HIDDEN_TIMEOUT/s/.*/#GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
  # Remove boot option "quiet" and "splash"
  sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
  sudo update-grub
}

disable_apport
add_lightdm_greeter_badges
configure_gtk
configure_grub
