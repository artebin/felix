#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME=openbox_badge-symbolic#1.svg

disableApport(){
  sudo sed -i '/^enabled=/s/.*/enabled=0/' /etc/default/apport
}

addLightdmGreeterOpenboxBadge(){
  cd ${BASEDIR}/lightdm-greeter-badge
  sudo cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  sudo gtk-update-icon-cache /usr/share/icons/hicolor
}

# Grub
# => Remove hidden timeout 0
# => Remove boot option "quiet" and "splash"
sudo sed -i '/^GRUB_HIDDEN_TIMEOUT/s/#GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
sudo update-grub

# Disable Apport
disableApport

# lightdm greeter openbox badge
addLightdmGreeterOpenboxBadge
