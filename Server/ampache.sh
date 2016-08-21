#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_packages(){
  xargs sudo apt-get -y install < ./packages.ampache.list
}

configure_ampache(){
}

install_packages
configure_ampache
