#!/usr/bin/env bash

#
# LibreOffice is not looking at the WM desktops and opens its windows in
# the desktop where existing soffice windows are located. This script
# starts a single instance of soffice: when started, the windows will be
# located in the current WM desktop.
#
# This script can be installed as an aternative for soffice:
# $sudo cp soffice_single_instance.sh /usr/local/bin
# $sudo chmod 755 /usr/local/bin/soffice_single_instance.sh
# $sudo update-alternatives --install /usr/bin/soffice soffice /usr/local/bin/soffice_single_instance.sh 10
#

TIMESTAMP="$(date -u +'%y%m%d-%H%M%S.%3N')"
USER_INSTALLATION_DIR="/tmp/${USER}/soffice/${TIMESTAMP}"
mkdir -p "${USER_INSTALLATION_DIR}"
/usr/lib/libreoffice/program/soffice --accept="pipe,name=soffice-pipe-uuid;urp;StarOffice.ServiceManager" -env:UserInstallation="file://${USER_INSTALLATION_DIR}" ${@}
wait
rm -fr "${USER_INSTALLATION_DIR}"
