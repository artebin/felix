#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

sudo apt-get update
sudo apt-get -y upgrade

# Ask user for installing group of packages?
#while read -r line; do sudo apt-get install "$line"; done < ./packages.list

# Install everything without asking
xargs sudo apt-get -y install < ./packages.list

sudo apt-get -y remove file-roller
sudo apt-get -y autoremove
