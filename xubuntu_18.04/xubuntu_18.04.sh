#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE})/../common.sh"

INSTALLER_MEDIA_INFO_PATH="/var/log/installer/media-info"
SUPPORTED_XUBUNTU_VERSION="Xubuntu 18.04"

check_ubuntu_version(){
	if [ ! -f "${INSTALLER_MEDIA_INFO_PATH}" ]; then
		echo "Unable to find file ${INSTALLER_MEDIA_INFO_PATH}"
		echo "Can not check Xubuntu version"
		exit 1
	fi
	if ! grep -Fq "${SUPPORTED_XUBUNTU_VERSION}" "${INSTALLER_MEDIA_INFO_PATH}"; then
		echo "This script has not been tested with: $(cat /var/log/installer/media-info)"
		exit 1
	fi
	echo "Check Xubuntu version: ${SUPPORTED_XUBUNTU_VERSION} => OK"
}

retrieve_log_file_name(){
	if [ $# -ne 1 ]; then
		echo "retrieve_log_file_name() expects file_name in argument"
		exit 1
	fi
	FILE_NAME="${1}"
	LOG_FILE_NAME="${FILE_NAME%.*}.log.$(date -u +'%y%m%d-%H%M%S')"
	echo "${LOG_FILE_NAME}"
}

list_log_files(){
	find . -iname "*.log.*" -type f
}

delete_log_files(){
	find . -name "*.log.*" -type f -exec rm -fr {} \; 
}

RECIPE_NAME_REGEX="([0-9][0-9][0-9][0-9])-([us])-(.*)"

CURRENT_SCRIPT_FILE_PATH=$(readlink -f "$0")
CURRENT_SCRIPT_FILE_NAME=$(basename "$0")
CURRENT_SCRIPT_LOG_FILE_NAME=$(retrieve_log_file_name "${CURRENT_SCRIPT_FILE_NAME}")
BASEDIR=$(dirname "${CURRENT_SCRIPT_FILE_PATH}")

TEST_PACKAGE_AVAILABILITY="true"

GTK_ICON_THEME_NAME="Faenza-njames"
GTK_THEME_NAME="Adwaita"

XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT="altgr-intl"
XKBOPTIONS=""

LOCALES_TO_GENERATE="en_US.UTF-8 en_GB.UTF-8 fr_FR.UTF-8"
LOCALE_TO_USE_LANG="en_US.UTF-8"
LOCALE_TO_USE_LC_NUMERIC="en_US.UTF-8"
LOCALE_TO_USE_LC_TIME="en_GB.UTF-8"
LOCALE_TO_USE_LC_MONETARY="fr_FR.UTF-8"
LOCALE_TO_USE_LC_PAPER="fr_FR.UTF-8"
LOCALE_TO_USE_LC_NAME="fr_FR.UTF-8"
LOCALE_TO_USE_LC_ADDRESS="fr_FR.UTF-8"
LOCALE_TO_USE_LC_TELEPHONE="fr_FR.UTF-8"
LOCALE_TO_USE_LC_MEASUREMENT="fr_FR.UTF-8"
LOCALE_TO_USE_LC_IDENTIFICATION="fr_FR.UTF-8"

LOCAL_TIME_ZONE="Europe/Brussels"
