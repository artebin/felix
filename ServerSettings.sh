#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_server_packages(){
  xargs sudo apt-get -y install < ./packages.server.install.list
}

deluge_deamon(){
  echo "Configuring deluge deamon ..."
  sudo useradd deluge
  cd /home/deluge
  sudo su deluge
  deluged -c /home/deluge/.config/deluge
  echo "njames:password:10" >> ~/.config/deluge/auth
  deluge-console "config -s allow_remote True"
  deluge-console "config allow_remote"
}

install_server_packages
configure_deluge_deamon
