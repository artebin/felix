#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

GTK_ICON_THEME_NAME="Faenza-Dark"
GTK_THEME_NAME="Greybird"

configure_gtk(){
  cd ${BASEDIR}
  echo "Configuring GTK+ ..."

  # GTK+ 2.0
  if [ ! -f /etc/gtk-2.0/gtkrc  ]; then
    cp system.gtkrc-2.0 /etc/gtk-2.0/gtkrc
    chmod 755 /etc/gtk-2.0/gtkrc
  fi
  sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
  sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc

  # GTK+ 3.0
  if [ ! -f /etc/gtk-3.0/settings.ini ]; then
    cp system.gtkrc-3.0 /etc/gtk-3.0/settings.ini
    chmod 755 /etc/gtk-3.0/settings.ini
  fi
  sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
  sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini

  # Disable the scrollbar overlay introduced in GTK+ 3.16
  # Cannot find a property in gtkrc-3.0 for that...
  echo "GTK_OVERLAY_SCROLLING=0" | sudo tee -a /etc/environment
  # Disable SWT_GTK3 (use GTK+ 2.0 for SWT)
  echo "SWT_GTK3=0" | sudo tee -a /etc/environment
  
  # It would be better to put the 2 env. variables above in Xsession.d as it will be less likely to conflict 
  # with updates made by the packaging system but sudo/root would not have them => can not use the 2 lines below:
  #echo "export GTK_OVERLAY_SCROLLING=0" | sudo tee /etc/X11/Xsession.d/80gtk-overlay-scrolling
  #echo "export SWT_GTK3=0" | sudo tee /etc/X11/Xsession.d/80swt-gtk

  # Add gtk.css for root
  mkdir -p /root/.config/gtk-3.0
  cp gtk.css /root/.config/gtk-3.0/gtk.css
}

cd ${BASEDIR}
configure_gtk 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
