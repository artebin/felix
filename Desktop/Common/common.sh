#!/bin/sh

getFileNameForBackup(){
  SUFFIX=${1}.bak.$(date +"%y%m%d-%H%M%S")
  echo ${SUFFIX}
}

renameFileForBackup(){
  BACKUP_FILE=$(getFileNameForBackup "$1")
  echo "Renamed existing file ${1} to ${BACKUP_FILE}"
  mv "$1" ${BACKUP_FILE}
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

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
