#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_server_packages(){
  xargs sudo apt-get -y install < ./packages.server.install.list
}

# Add creditentials for user: echo "${user}:${password}:10 >> /home/deluge/.config/auth
# For using server and client on the same machine but started by different users: copy local creditential from server auth file into the auth file of the user which start the client.
configure_deluge_deamon(){
  echo "Configuring deluge deamon ..."
  sudo useradd deluge --base-dir /home/deluge
  sudo runuser -l deluge -c 'sh configure_deluge_deamon.sh'
}

#install_server_packages
configure_deluge_deamon
