#!/bin/sh

. ../../Common/common.sh

retrieve_mac_book_air_product_name(){
  printSectionHeading "Retrieving MacBook Air product name"
  sudo dmidecode -s system-product-name
  printSectionEnding
}

configure_apple_hid(){
  printSectionHeading "Configuring apple hid (use fn key for special functions keys)"
  echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
  sudo update-initramfs -u -k all
  printSectionEnding
}	

# Trackpad is too sentitive: a tap is issued after scrolling
configure_trackpad(){
  printSectionHeading "Configuring trackpad sensitivity"
  echo "synclient FingerLow=110 FingerHigh=120" | tee -a ~/.config/openbox/autostart
  printSectionEnding
}

configure_xmodmap(){
  printSectionHeading "Configuring xmodmap (.xmodmaprc includes fix for backtick and tilde keys)"
  cd ${BASEDIR}
  if [ -f ~/.xmodmaprc ]; then
    renameFileForBackup ~/.xmodmaprc
  fi
  cp xmodmaprc ~/.xmodmaprc
  echo "Configuring openbox for xmodmap autostart ..."
  echo "xmodmap ~/.xmodmaprc &" | tee -a ~/.config/openbox/autostart
  printSectionEnding
}	

tune_power_save_functions(){
  printSectionHeading "Tuning power save functions"
  sudo apt-get install -y powertop
  sudo apt-get install -y tlp tlp-rdw
  printSectionEnding
}	

install_facetimehd(){
  printSectionHeading "Installing FacetimeHD"
  cd ${BASEDIR}
  tar xjf cpio-2.12.tar.bz2
  cd cpio-2.12
  ./configure;make
  sudo make install
  cd ${BASEDIR}
  unzip bcwc_pcie-master.zip
  cd bcwc_pcie-master
  cd firmware
  make
  sudo make install
  cd ${BASEDIR}/bcwc_pcie-master
  sudo apt-get install linux-headers-generic git kmod libssl-dev checkinstall
  sudo checkinstall
  sudo depmod
  sudo modprobe facetimehd
  sudo modprobe -r bdc_pci
  echo "blacklist bdc_pci" | sudo tee /etc/modprobe.d/blacklist.conf
  echo "You can test your configuration with \'mplayer tv://\'"
  printSectionEnding
}

#retrieve_mac_book_air_product_name 2>&1 | tee -a StdOutErr.log
#configure_apple_hid 2>&1 | tee -a StdOutErr.log
#configure_trackpad 2>&1 | tee -a StdOutErr.log
#configure_xmodmap 2>&1 | tee -a StdOutErr.log
#tune_power_save_functions 2>&1 | tee -a StdOutErr.log
install_facetimehd 2>&1 | tee -a StdOutErr.log

