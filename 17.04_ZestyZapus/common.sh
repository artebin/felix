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
    exit 1
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
    exit 1
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

delete_log_files(){
  if [ ! -d ${1} ]; then
    echo "parameter 1 should be a directory";
    exit 1;
  fi
  find ${1} -name *.log.* -type f -exec rm -fr {} \; 
}

escape_sed_pattern(){
	printf "${1}" | sed -e 's/[\/&]/\\&/g'
}

GTK_ICON_THEME_NAME="Faenza-njames"
GTK_THEME_NAME="Greybird"

LOCALE_TO_USE_LANG="en_US.UTF-8"
LOCALE_TO_USE_LC_NUMERIC="en_US.UTF-8"
LOCALE_TO_USE_LC_TIME="en_US.UTF-8"
LOCALE_TO_USE_LC_MONETARY="fr_BE.UTF-8"
LOCALE_TO_USE_LC_PAPER="fr_BE.UTF-8"
LOCALE_TO_USE_LC_NAME="fr_BE.UTF-8"
LOCALE_TO_USE_LC_ADDRESS="fr_BE.UTF-8"
LOCALE_TO_USE_LC_TELEPHONE="fr_BE.UTF-8"
LOCALE_TO_USE_LC_MEASUREMENT="fr_BE.UTF-8"
LOCALE_TO_USE_LC_IDENTIFICATION="fr_BE.UTF-8"
