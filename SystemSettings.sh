#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

# Remove boot option "quiet" and "splash"


# Disable Apport
sudo sed -i '/^enabled=/s/.*/enabled=0=/' /etc/default/apport
