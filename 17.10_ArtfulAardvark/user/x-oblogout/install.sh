#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
  echo "This script needs to run with the bourne again shell (bash)!" 1>&2
  exit 1
fi

# To create the patch:
# $diff -ruN oblogout-master/ MUMUX-oblogout/ > MUMUX-oblogout.patch

OBLOGOUT_DIR=$(dirname "$0")
unzip -q oblogout-master.zip
patch -s -p0 < MUMUX-oblogout.patch
mv oblogout-master MUMUX-oblogout
mkdir ~/scripts
mv MUMUX-oblogout ~/scripts 
