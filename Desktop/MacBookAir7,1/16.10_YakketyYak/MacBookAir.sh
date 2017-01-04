#!/bin/sh

. ../../Common/common.sh

retrieve_mac_book_air_product_name(){
  printSectionHeading "Retrieving MacBook Air product name"
  sudo dmidecode -s system-product-name
  printSectionEnding
}

configure_apple_hid(){
  echo "Configuring apple hid (use fn key for special functions keys) ..."
  echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
  sudo update-initramfs -u -k all
}	

# Trackpad is too sentitive: a tap is issued after scrolling
configure_trackpad(){
  echo "Configuring trackpad sensitivity ..."
  echo "synclient FingerLow=110 FingerHigh=120" | tee -a ~/.config/openbox/autostart
}

configure_xmodmap(){
  echo "Configuring xmodmap (.xmodmaprc includes fix for backtick and tilde keys) ..."
  cd ${BASEDIR}
  if [ -f ~/.xmodmaprc ]; then
    renameFileForBackup ~/.xmodmaprc
  fi
  cp xmodmaprc ~/.xmodmaprc
  echo "Configuring openbox for xmodmap autostart ..."
  echo "xmodmap ~/.xmodmaprc &" | tee -a ~/.config/openbox/autostart
}	

tune_power_save_functions(){
  echo "Tuning power save functions ..."
  sudo apt-get install -y powertop
  sudo apt-get install -y tlp tlp-rdw
}	

install_facetimehd(){
  echo "Installing FacetimeHD ..."
  cd ${BASEDIR}i
  tar xjf cpio-2.12.tar.bz
  cd cpio-2.12
  ./configure;make
  sudo make install
  cd ${BASEDIR}
  unzip bcwc_pcie-master.zip
  cd bcwc_pcie-master
  cd firmware
  make
  sudo make install
  cd ${BASEDIR}/bcwc_pciemaster
  sudo apt-get install linux-headers-generic git kmod libssl-dev checkinstall
  sudo checkinstall
  sudo depmod
  sudo modprobe facetimehd
  sudo modprobe -r bdc_pci
  echo "blacklist bdc_pci" | sudo tee /etc/modprobe.d/blacklist.conf
  echo "You can test your configuration with \'mplayer tv://\'"
}

retrieve_mac_book_air_product_name
#configure_apple_hid
#configure_trackpad
#configure_xmodmap
#tune_power_save_functions
#install_facetimehd

