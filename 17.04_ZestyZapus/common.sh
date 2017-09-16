#!/bin/bash

check_shell(){
  if [ ! "${BASH_VERSION}" ] ; then
    echo "This script should run with bash!" 1>&2
    exit 1
  fi
}

get_root_privileges(){
  if [ ${EUID} -ne 0 ]; then
    echo "This script needs the root priveleges!"
    sudo "$0" "$@"
    exit $?
  fi
}

INSTALLER_MEDIA_INFO_PATH="/var/log/installer/media-info"
SUPPORTED_XUBUNTU_VERSION="Xubuntu 17.04"

check_xubuntu_version(){
  if [ ! -f ${INSTALLER_MEDIA_INFO_PATH} ]; then
    echo "Unable to find file ${INSTALLER_MEDIA_INFO_PATH}"
    echo "Cannot check Xubuntu version!"
    exit 1
  fi
  if ! grep -Fq "${SUPPORTED_XUBUNTU_VERSION}" ${INSTALLER_MEDIA_INFO_PATH}; then
    echo "This script has not been tested with: $(cat /var/log/installer/media-info)"
    return 1
  fi
}

getFileNameForBackup(){
  SUFFIX="${1}.bak.$(date +'%y%m%d-%H%M%S')"
  echo ${SUFFIX}
}

renameFileForBackup(){
  if [ -f ${1} ]; then
  BACKUP_FILE=$(getFileNameForBackup "$1")
  echo "Renamed existing file ${1} to ${BACKUP_FILE}"
  mv "$1" ${BACKUP_FILE}
  fi
}

printSectionHeading(){
  echo "###############################################################################################"
  echo "# ${1}"
  echo "###############################################################################################"
}

printSectionEnding(){
  echo ""
  echo ""
  echo ""
}

SCRIPT_NAME=$(basename "$0")
SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
