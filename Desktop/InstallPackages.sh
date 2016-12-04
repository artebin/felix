#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

sudo apt-get update
sudo apt-get -y upgrade

xargs sudo apt-get -y remove < ./packages.desktop.remove.list
sudo apt-get -y autoremove

xargs sudo apt-get -y install < ./packages.desktop.install.list

# Remarquable
https://remarkableapp.github.io/files/remarkable_1.87_all.deb
