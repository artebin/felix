#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "Please run with root privileges"
  exit
fi

. ./common.sh

upgrade_system(){
sudo apt-get update
sudo apt-get -y upgrade
}

process_package_remove_list(){
xargs sudo apt-get -y remove < ./packages.desktop.remove.list
sudo apt-get -y autoremove
}

process_package_install_list(){
xargs sudo apt-get -y install < ./packages.desktop.install.list
}

install_chrome(){
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update 
sudo apt-get install google-chrome-stable
}

install_remarquable(){
wget https://remarkableapp.github.io/files/remarkable_1.87_all.deb
dpkg -i remarkable_1.87_all.deb
rm -f remarkable_1.87_all.deb
}

install_skype(){
sudo dpkg --add-architecture i386
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update && sudo apt-get install skype
}

install_mate_1_17(){
sudo add-apt-repository ppa:jonathonf/mate-1.17
sudo apt-get update
sudo apt-get upgrade
}

upgrade_system
process_package_remove_list
process_package_install_list
install_chrome
install_remarquable
install_skype
#install_mate_1_17
