#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

install_packages(){
  xargs sudo apt-get -y install < ./packages.ampache.list
}

install_packages
x-www-browser http://localhost/ampache/
