#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_packages(){
  xargs sudo apt-get -y install < ./packages.deluge.deamon.list
}

# Add creditentials for user: echo "${user}:${password}:10 >> /home/deluge/.config/auth
# For using server and client on the same machine but started by different users: copy local creditential from server auth file into the auth file of the user which start the client.
configure_deluge_deamon(){
  echo "Configuring deluge deamon ..."
  sudo useradd deluge --create-home
  sudo runuser -l deluge -c 'cd /home/deluge;\
                             deluged -c /home/deluge/.config/deluge;\
                             deluge-console "config -s allow_remote True";\
                             deluge-console "config allow_remote";\
                             mkdir deluge.uncompleted;\
                             mkdir deluge.completed;\
                             mkdir deluge.torrent;\
                             killall deluged'
}

install_packages
configure_deluge_deamon
