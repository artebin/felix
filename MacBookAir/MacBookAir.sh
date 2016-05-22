#!/bin/sh

BASEDIR=$(dirname "$0")

# Retrieve MacBook Air product name
sudo dmidecode -s system-product-name

# Function keys (fn+Fkeys for special function keys)
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all

# Backtick and tilde keys via xmodmap
#echo "keycode 94 = grave asciitilde" | tee -a ~/.xmodmaprc
cd ${BASEDIR}
if [ -f ~/.xmodmaprc ]; then
  mv ~/.xmodmaprc ~/.xmodmaprc.bak
fi
cp xmodmaprc ~/.xmodmaprc
echo "xmodmap ~/.xmodmaprc &" | tee -a ~/.config/openbox/autostart

# Finetuning powersave functions
sudo apt-get install -y powertop
sudo apt-get install -y tlp tlp-rdw

# Suspend/resume backlight issue
cd ${BASEDIR}/MacBookAir
git clone git://github.com/patjak/mba6x_bl
cd mba6x_bl
make
sudo make install
sudo depmod -a
sudo modprobe mba6x_bl
