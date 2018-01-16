#!/bin/bash

check_shell(){
	if [[ ! "${BASH_VERSION}" ]] ; then
		echo 'This script should run with bash' 1>&2
		exit 1
	fi
}

has_root_privileges(){
	if [[ "${EUID}" -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

exit_if_has_not_root_privileges(){
	if ! has_root_privileges; then
		echo 'This script needs the root priveleges'
		exit 1
	fi
}

INSTALLER_MEDIA_INFO_PATH='/var/log/installer/media-info'
SUPPORTED_XUBUNTU_VERSION='Xubuntu 17.04'

check_xubuntu_version(){
	if [[ ! -f "${INSTALLER_MEDIA_INFO_PATH}" ]]; then
		echo "Unable to find file ${INSTALLER_MEDIA_INFO_PATH}"
		echo 'Cannot check Xubuntu version'
		exit 1
	fi
	if ! grep -Fq "${SUPPORTED_XUBUNTU_VERSION}" "${INSTALLER_MEDIA_INFO_PATH}"; then
		echo "This script has not been tested with: $(cat /var/log/installer/media-info)"
		exit 1
	fi
	echo 'Xubuntu version check: OK'
}

backup_file(){
	if [[ "$#" -ne 2 ]]; then
		echo 'Function backup_file should be called with an argument'
		exit 1
	fi
	if [[ ! -f "${2}" ]]; then
		echo "Can not find ${2}"
		exit 1
	fi
	FILE_BACKUP_PATH="${2}.bak.$(date +'%y%m%d-%H%M%S')"
	case "${1}" in
		'rename')
			mv "${2}" "${FILE_BACKUP_PATH}"
			if [[ "$?" -ne 0 ]]; then
				echo "Can not backup file ${2}"
				exit 1
			fi
			;;
		'copy')
			cp "${2}" "${FILE_BACKUP_PATH}"
			if [[ "$?" -ne 0 ]]; then
				echo "Can not backup file ${2}"
				exit 1
			fi
			;;
		*)
			echo "Unkown argument ${1}"
			exit 1
	esac
}

print_section_heading(){
	echo '###############################################################################################'
	echo "# ${1}"
	echo '###############################################################################################'
}

print_section_ending(){
	echo
	echo
	echo
}

SCRIPT_NAME=$(basename "$0")
SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})
SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"

list_log_files(){
	find . -iname '*.log.*' -type f
}

delete_log_files(){
	find . -name '*.log.*' -type f -exec rm -fr {} \; 
}

escape_sed_pattern(){
	printf "${1}" | sed -e 's/[\/&]/\\&/g'
}

add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${FILE_PATH}"
	fi
}

GTK_ICON_THEME_NAME='Faenza-njames'
GTK_THEME_NAME='Greybird'

LOCALES_TO_GENERATE='en_US.UTF-8 en_GB.UTF-8 fr_FR.UTF-8'
LOCALE_TO_USE_LANG='en_US.UTF-8'
LOCALE_TO_USE_LC_NUMERIC='en_US.UTF-8'
LOCALE_TO_USE_LC_TIME='en_GB.UTF-8'
LOCALE_TO_USE_LC_MONETARY='fr_FR.UTF-8'
LOCALE_TO_USE_LC_PAPER='fr_FR.UTF-8'
LOCALE_TO_USE_LC_NAME='fr_FR.UTF-8'
LOCALE_TO_USE_LC_ADDRESS='fr_FR.UTF-8'
LOCALE_TO_USE_LC_TELEPHONE='fr_FR.UTF-8'
LOCALE_TO_USE_LC_MEASUREMENT='fr_FR.UTF-8'
LOCALE_TO_USE_LC_IDENTIFICATION='fr_FR.UTF-8'
