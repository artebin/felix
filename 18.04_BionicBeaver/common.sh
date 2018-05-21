#!/bin/bash

check_shell(){
	if [ ! "${BASH_VERSION}" ] ; then
		echo "This script should run with bash" 1>&2
		exit 1
	fi
}

has_root_privileges(){
	if [ "${EUID}" -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

exit_if_has_not_root_privileges(){
	if ! has_root_privileges; then
		echo "This script needs the root priveleges"
		exit 1
	fi
}

INSTALLER_MEDIA_INFO_PATH="/var/log/installer/media-info"
SUPPORTED_XUBUNTU_VERSION="Xubuntu 18.04"

check_xubuntu_version(){
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

backup_file(){
	if [ "$#" -ne 2 ]; then
		echo "backup_file() expects path in argument"
		exit 1
	fi
	if [ ! -e "${2}" ]; then
		echo "Can not find ${2}"
		exit 1
	fi
	FILE_BACKUP_PATH="${2}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${1}" in
		"rename")
			mv "${2}" "${FILE_BACKUP_PATH}"
			if [ "$?" -ne 0 ]; then
				echo "Can not backup file ${2}"
				exit 1
			fi
			;;
		"copy")
			cp "${2}" "${FILE_BACKUP_PATH}"
			if [ "$?" -ne 0 ]; then
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
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo "# ${1}"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

print_section_ending(){
	echo
	echo
	echo
}

list_log_files(){
	find . -iname "*.log.*" -type f
}

delete_log_files(){
	find . -name "*.log.*" -type f -exec rm -fr {} \; 
}

escape_sed_pattern(){
	printf "${1}" | sed 's/\//\\\//g' | sed 's/\+/\\\+/g'
}

add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${FILE_PATH}"
	fi
}

yes_no_dialog(){
	if [ "$#" -ne 1 ]; then
		echo "ERROR! yes_no_dialog() expects one argument"
		return 1
	fi
	DIALOG_TEXT="${1}"
	while true; do
		read -p "${DIALOG_TEXT} [y/n] " USER_ANSWER
		case "${USER_ANSWER}" in
			[Yy]* )
				printf "yes"
				break
				;;
			[Nn]* )
				printf "no"
				break
				;;
			* )
				printf "Please answer yes or no\n\n" > /dev/stderr
				;;
		esac
	done
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
