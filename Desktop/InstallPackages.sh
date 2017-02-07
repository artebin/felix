#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "Please run with root privileges"
  exit
fi

. ../common.sh

upgrade_system(){
sudo apt-get update
sudo apt-get -y upgrade
}

process_package_remove_list(){
xargs sudo apt-get -y remove < ./packages.desktop.remove.list
}

process_package_install_list(){
xargs sudo apt-get -y install < ./packages.desktop.install.list
}

install_chrome(){
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install google-chrome-stable -y
}

install_remarquable(){
cd ${BASEDIR}
wget https://remarkableapp.github.io/files/remarkable_1.87_all.deb
dpkg -i remarkable_1.87_all.deb
rm -f remarkable_1.87_all.deb
}

install_skype(){
sudo dpkg --add-architecture i386
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update 
sudo apt-get install skype -y
}

install_pasystray(){
cd ${BASEDIR}
git clone http://github.com/christophgysin/pasystray
cd pasystray
./bootstrap.sh
./configure
make
make install
cd ${BASEDIR}
rm -fr pasystray
}

install_mate_1_17(){
sudo add-apt-repository ppa:jonathonf/mate-1.17
sudo apt-get update
sudo apt-get upgrade
}

# For dokuwiki
# apt-get install apache2 php php-mbstring -y
# enable mod userdir
# allow php in userdir by editing /etc/apache2/mods-available/php7.0.conf

clean(){
  sudo apt-get -y autoremove
}

LOGFILE="InstallPackages.StdOutErr.log"
renameFileForBackup ${LOGFILE}

upgrade_system 2>&1 | tee -a ${LOGFILE}
process_package_remove_list 2>&1 | tee -a ${LOGFILE}
process_package_install_list 2>&1 | tee -a ${LOGFILE}
install_chrome 2>&1 | tee -a ${LOGFILE}
install_remarquable 2>&1 | tee -a ${LOGFILE}
install_skype 2>&1 | tee -a ${LOGFILE}
install_pasystray 2>&1 | tee -a ${LOGFILE}
#install_mate_1_17 2>&1 | tee -a ${LOGFILE}

clean 2>&1 | tee -a ${LOGFILE}
