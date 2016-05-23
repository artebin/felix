#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME=openbox_badge-symbolic#1.svg

disableApport(){
  sudo sed -i '/^enabled=/s/.*/enabled=0=/' /etc/default/apport
}

addLightdmGreeterOpenboxBadge(){
  cd ${BASEDIR}/lightdm-greeter-badge
  sudo cp ${LIGHTDM_GREETER_OPENBOX_BADGE_FILE_NAME} /usr/share/icons/hicolor/scalable/places/openbox_badge-symbolic.svg
  sudo gtk-update-icon-cache /usr/share/icons/hicolor
}

# Remove boot option "quiet" and "splash"


# Disable Apport
disableApport

# lightdm greeter openbox badge
addLightdmGreeterOpenboxBadge
