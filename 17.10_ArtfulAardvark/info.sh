#!/bin/bash

# Distribution name

# Ubuntu version
INSTALLER_MEDIA_INFO_PATH='/var/log/installer/media-info'
get_ubuntu_version(){
	if [[ ! -f "${INSTALLER_MEDIA_INFO_PATH}" ]]; then
		echo "Unable to find file ${INSTALLER_MEDIA_INFO_PATH}"
		echo 'Can not check get Ubuntu version'
		exit 1
	fi
	if ! grep -Fq "${SUPPORTED_XUBUNTU_VERSION}" "${INSTALLER_MEDIA_INFO_PATH}"; then
		echo "This script has not been tested with: $(cat /var/log/installer/media-info)"
		exit 1
	fi
	echo 'Xubuntu version check: OK'
}

# Linux kernel version

# GTK version

# Java version

# Screens number and resolution
