#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

renameFileForBackup(){
  SUFFIX=.bak.$(date +"%y%m%d-%H%M%S")
  mv "$1" "$1"${SUFFIX}
}

retrieveMacBookAirProductName(){
  sudo dmidecode -s system-product-name
}

useFnKeyForSpecialFunctionKeys(){
  echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
  sudo update-initramfs -u -k all
}	

setupXmodmaprcFileForBacktickAndTildeKeys(){
  cd ${BASEDIR}
  if [ -f ~/.xmodmaprc ]; then
    renameFileForBackup ~/.xmodmaprc
  fi
  cp xmodmaprc ~/.xmodmaprc
  echo "xmodmap ~/.xmodmaprc &" | tee -a ~/.config/openbox/autostart
}	

tunePowersaveFunctions(){
  sudo apt-get install -y powertop
  sudo apt-get install -y tlp tlp-rdw
}	

fixSuspendBacklight(){
  cd ${BASEDIR}/MacBookAir
  git clone git://github.com/patjak/mba6x_bl
  cd mba6x_bl
  make
  sudo make install
  sudo depmod -a
  sudo modprobe mba6x_bl
}

# Retrieve MacBook Air product name
retrieveMacBookAirProductName

# Function keys (fn+Fkeys for special function keys)
useFnKeyForSpecialFunctionKeys

# Backtick and tilde keys via xmodmap
setupXmodmaprcFileForBacktickAndTildeKeys

# Finetuning powersave functions
tunePowersaveFunctions

# Suspend/resume backlight issue
fixSuspendBacklight
