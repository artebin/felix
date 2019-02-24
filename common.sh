#!/usr/bin/env bash

is_linux_platform(){
	UNAME_OUTPUT=$(uname -a)
	LINUX_REGEX=".*GNU/Linux.*"
	if [[ "${UNAME_OUTPUT}" =~ ${LINUX_REGEX} ]]; then
		return 0
	else
		return 1
	fi
}

is_mac_platform(){
	UNAME_OUTPUT=$(uname -a)
	OSX_REGEX=".*Darwin Kernel.*"
	if [[ "${UNAME_OUTPUT}" =~ ${OSX_REGEX} ]]; then
		return 0
	else
		return 1
	fi
}

is_cygwin_platform(){
	UNAME_OUTPUT=$(uname -a)
	CYGWIN_REGEX=".*Cygwin.*"
	if [[ "${UNAME_OUTPUT}" =~ ${CYGWIN_REGEX} ]]; then
		return 0
	else
		return 1
	fi
}

exit_if_not_bash(){
	if [[ ! "${BASH_VERSION}" ]] ; then
		printf "This script should run with bash\n" 1>&2
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
		printf "This script needs the root priveleges\n" 1>&2
		exit 1
	fi
}

exit_if_has_root_privileges(){
	if has_root_privileges; then
		printf "This script should not be executed with the root priveleges\n" 1>&2
		exit 1
	fi
}

retrieve_absolute_path(){
	# The 'readlink' command can not be used on Mac platform to retrieve the absolute paths.
	# Internet says there's no simple way to do this and best solution is to invoke perl.
	if is_mac_platform; then
		ABSOLUTE_PATH=$(perl -e 'use Cwd "abs_path";print abs_path(shift)' "${1}")
		echo "${ABSOLUTE_PATH}"
	else
		ABSOLUTE_PATH=$(readlink -f "${1}")
		echo "${ABSOLUTE_PATH}"
	fi
}

escape_sed_pattern(){
	printf "${1}" | sed -e 's/[\\&]/\\&/g' | sed -e 's/[\/&]/\\&/g'
}

add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		if is_mac_platform; then
			sed -i '' "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
		else
			sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
		fi
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${FILE_PATH}"
	fi
}

add_or_update_keyvalue(){
	FILE_PATH="${1}"
	KEY="${2}"
	NEW_VALUE="${3}"
	ESCAPED_KEY=$(escape_sed_pattern "${KEY}")
	ESCAPED_NEW_VALUE=$(escape_sed_pattern "${NEW_VALUE}")
	if grep -q "^${ESCAPED_KEY}" "${FILE_PATH}"; then
		if is_mac_platform; then
			sed -i '' "/^${ESCAPED_KEY}=/s/.*/${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}/" "${FILE_PATH}"
		else
			sed -i "/^${ESCAPED_KEY}=/s/.*/${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}/" "${FILE_PATH}"
		fi
	else
		echo "${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}" >> "${FILE_PATH}"
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

print_section_heading(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	printf "# ${1}\n"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

print_section_ending(){
	echo
	echo
	echo
}

backup_file(){
	if [[ $# -ne 2 ]]; then
		echo "Function backup_file() expects BACKUP_MODE and FILE path as parameter"
		exit 1
	fi
	BACKUP_MODE="${1}"
	FILE="${2}"
	if [[ ! -e "${FILE}" ]]; then
		echo "Cannot find FILE: ${FILE}"
		exit 1
	fi
	FILE_BACKUP="${FILE}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${BACKUP_MODE}" in
		"rename")
			mv "${FILE}" "${FILE_BACKUP}"
			if [[ $? -ne 0 ]]; then
				echo "Cannot backup file: ${FILE}"
				exit 1
			fi
			;;
		"copy")
			cp "${FILE}" "${FILE_BACKUP}"
			if [[ $? -ne 0 ]]; then
				echo "Cannot backup file: ${FILE}"
				exit 1
			fi
			;;
		*)
			echo "Unknown BACKUP_MODE: ${BACKUP_MODE}"
			exit 1
	esac
}

convert_yymmdd_to_epoch(){
	DATE_IN_YYMMDD="${1}"
	EPOCH_IN_SECONDS=""
	if is_linux_platform; then
		EPOCH_IN_SECONDS=$(date -u --date="${DATE_IN_YYMMDD}" +%s)
	elif is_mac_platform; then
		 EPOCH_IN_SECONDS=$(date -ju -f "%y%m%d%H%M%S" "${DATE_IN_YYMMDD}000000" +"%s")
	fi
	printf "${EPOCH_IN_SECONDS}"
}

convert_hhmmss_time_duration_to_seconds(){
	TIME_DURATION_IN_HHMMSS="${1}"
	TIME_DURATION_IN_SECONDS=$(echo "${TIME_DURATION_IN_HHMMSS}"|awk '{print substr($1,1,2)*60*60 + substr($1,3,2)*60 + substr($1,5,2)}')
	printf "${TIME_DURATION_IN_SECONDS}"
}

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

is_package_available(){
	if [[ $# -ne 1 ]]; then
		printf "Function is_package_available() expects PACKAGE_NAME as argument\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	apt-cache --quiet=0 showpkg "${PACKAGE_NAME}" 2>&1|grep -q 'Unable to locate package'
	IS_PACKAGE_NOT_AVAILABLE=$?
	if [[ ${IS_PACKAGE_NOT_AVAILABLE} -eq 0 ]]; then
		return 1
	else
		return 0
	fi
}

retrieve_package_short_description(){
	if [[ $# -ne 1 ]]; then
		printf "Function retrieve_package_short_description() expects PACKAGE_NAME as argument\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	PACKAGE_DESCRIPTION=$(apt-cache show "${PACKAGE_NAME}"|grep -m 1 "Description-en: "|sed 's/Description-en: //g'|sed 's/^\s\+//g'|sed 's/\s\+$//g')
	printf "${PACKAGE_DESCRIPTION}"
}

generate_apt_package_list_file(){
	if [[ ! $# -ne 2 ]]; then
		printf "Function generate_apt_package_list_file() expects PACKAGE_LIST_FILE, APT_PACKAGE_LIST_FILE and PACKAGE_MISSING_LIST_FILE as parameter\n" 1>&2
		exit 1
	fi
	PACKAGE_LIST_FILE="${1}"
	APT_PACKAGE_LIST_FILE="${2}"
	PACKAGE_MISSING_LIST_FILE="${3}"
	if [[ ! -f "${PACKAGE_LIST_FILE}" ]]; then
		printf "Cannot find PACKAGE_LIST_FILE: ${PACKAGE_LIST_FILE}\n" 1>&2
		exit 1
	fi
	if [[ -f "${APT_PACKAGE_LIST_FILE}" ]]; then
		printf "File already exists: ${APT_PACKAGE_LIST_FILE}\n" 1>&2
		exit 1
	fi
	if [[ -f "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		printf "File already exists: ${PACKAGE_MISSING_LIST_FILE}\n" 1>&2
		exit 1
	fi
	while read LINE; do
		# A line can contain a comment starting with the character hash '#'
		PACKAGES_LINE="${LINE%%#*}"
		PACKAGES_LINE=$(echo "${PACKAGES_LINE}"|awk '{$1=$1};1')
		if [[ -z "${PACKAGES_LINE}" ]]; then
			continue
		fi
		for PACKAGE_NAME in ${PACKAGES_LINE}; do
			INFO_AVAILABLE=$'\e[39m\e[0m'
			INFO_INSTALLATION_STATUS=$'\e[39m\e[0m'
			INFO_PACKAGE_NAME="${PACKAGE_NAME}"
			INFO_PACKAGE_DESCRIPTION=""
			if is_package_available "${PACKAGE_NAME}"; then
				printf "${PACKAGE_NAME}\n" >>"${APT_PACKAGE_LIST_FILE}"
				INFO_AVAILABLE=$'\e[92mAVAILABLE\e[0m'
				INFO_PACKAGE_DESCRIPTION=$(retrieve_package_short_description "${PACKAGE_NAME}")
				if is_package_installed "${PACKAGE_NAME}"; then
					INFO_INSTALLATION_STATUS=$'\e[92mINSTALLED\e[0m'
				else
					INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
				fi
			else
				printf "{PACKAGE_NAME}\n" >>"${PACKAGE_MISSING_LIST_FILE}"
				INFO_AVAILABLE=$'\e[91mMISSING\e[0m'
				INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
			fi
			if [[ ! -z "${INFO_PACKAGE_DESCRIPTION}" ]]; then
				INFO_PACKAGE_DESCRIPTION=": ${INFO_PACKAGE_DESCRIPTION}"
			fi
			printf "[%-25s] [%-25s] %s%s\n" "${INFO_AVAILABLE}" "${INFO_INSTALLATION_STATUS}" "${INFO_PACKAGE_NAME}" "${INFO_PACKAGE_DESCRIPTION}"
		done
	done <"${PACKAGE_LIST_FILE}"
	if [[ -s "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		return 0
	else
		return 1
	fi
}

is_package_installed(){
	if [[ $# -ne 1 ]]; then
		printf "Function is_package_installed() expects PACKAGE_NAME as argument\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	dpkg-query -W -f='${Status}' "${PACKAGE_NAME}" 2>&1|grep -q 'ok installed'
	IS_PACKAGE_INSTALLED=$?
	if [[ ${IS_PACKAGE_INSTALLED} -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

install_package_if_not_installed(){
	if [[ ! $# -ge 1 ]]; then
		printf "Function install_package_if_not_installed() expects at least one package name as parameter\n" 1>&2
		exit 1
	fi
	for PACKAGE_NAME in $@; do
		if $(is_package_installed "${PACKAGE_NAME}"); then
			printf "Package is already installed: ${PACKAGE_NAME}\n"
		else
			printf "Installing package: ${PACKAGE_NAME} ...\n"
			apt-get install -y "${PACKAGE_NAME}"
		fi
	done
}

remove_with_purge_package_if_installed(){
	if [[ ! $# -ge 1 ]]; then
		printf "Function remove_with_purge_package_if_installed() expects at least one package name as parameter\n" 1>&2
		exit 1
	fi
	for PACKAGE_NAME in $@; do
		if ! $(is_package_installed "${PACKAGE_NAME}"); then
			printf "Package not removed because not installed: ${PACKAGE_NAME}\n"
		else
			printf "Removing package: ${PACKAGE_NAME} ...\n"
			apt-get remove --purge -y "${PACKAGE_NAME}"
		fi
	done
}
