#!/bin/sh

. ../Common/common.sh

clean(){
  echo "Cleaning ..."
  cd ${BASEDIR}
  rm -fr mba6x_bl
  rm -f xserver-xorg-video-intel_2.99.917+git20160706-1ubuntu1_amd64.deb
}

retrieve_mac_book_air_product_name(){
  echo "Retrieving MacBook Air product name..."
  sudo dmidecode -s system-product-name
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

fix_suspend_resume_backlight_issue(){
  echo "Fixing suspend/resume backlight issue ..."
  cd ${BASEDIR}
  git clone git://github.com/patjak/mba6x_bl
  cd mba6x_bl
  make
  sudo make install
  sudo depmod -a
  sudo modprobe mba6x_bl
}

# If you are using Xubuntu 16.04 then you maybe experience the bug #1568604 "Mouse cursor lost when unlocking with Intel graphics". 
# https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1568604 
#You can reinstall the intel driver version 2:2.99.917+git20160706-1ubuntu1 https://launchpad.net/ubuntu/yakkety/+package/xserver-xorg-video-intel
fix_bug_1568604(){
  echo "Fixing bug #1568604 ..."
  cd ${BASEDIR}
  sudo dpkg -P xserver-xorg-video-intel
  wget http://launchpadlibrarian.net/271461135/xserver-xorg-video-intel_2.99.917+git20160706-1ubuntu1_amd64.deb
  sudo dpkg -i xserver-xorg-video-intel_2.99.917+git20160706-1ubuntu1_amd64.deb
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
configure_apple_hid
configure_trackpad
configure_xmodmap
tune_power_save_functions
fix_suspend_resume_backlight_issue
fix_bug_1568604
install_facetimehd
clean
