#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_chrome(){
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update 
sudo apt-get install google-chrome-stable
}

install_remarquable(){
https://remarkableapp.github.io/files/remarkable_1.87_all.deb
}

install_skype(){
sudo dpkg --add-architecture i386
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update && sudo apt-get install skype
}

sudo apt-get update
sudo apt-get -y upgrade

xargs sudo apt-get -y remove < ./packages.desktop.remove.list
sudo apt-get -y autoremove

xargs sudo apt-get -y install < ./packages.desktop.install.list

install_chrome
install_remarquable
install_skype
