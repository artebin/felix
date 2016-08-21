#!/bin/sh

. ../common.sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

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

# Trackpad is too sentitive: after releasing the pad for a scrolling, a tap is issued.
configure_trackpad(){
  echo "Configure trackpad sensitivity ..."
  synclient FingerLow=110 FingerHigh=120
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

retrieve_mac_book_air_product_name
configure_apple_hid
configure_trackpad
configure_xmodmap
tune_power_save_functions
fix_suspend_resume_backlight_issue
fix_bug_1568604
cleaning
