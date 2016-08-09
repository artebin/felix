#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

sudo apt-get update
sudo apt-get -y upgrade

xargs sudo apt-get -y remove < ./packagesToRemove.list
sudo apt-get -y autoremove

xargs sudo apt-get -y install < ./packagesToInstall.list
