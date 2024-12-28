#!/usr/bin/env bash

exit_if_not_bash(){
	if [[ ! "${BASH_VERSION}" ]] ; then
		printf "This script should run with bash\n" 1>&2
		exit 1
	fi
}

exit_if_no_x_session(){
	if [[ -z "${DISPLAY}" ]] ; then
		printf "This script should run within a X session\n" 1>&2
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

escape_sed_pattern(){
	printf "${1}" | sed -e 's/[\\&]/\\&/g' | sed -e 's/[\/&]/\\&/g'
}

update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
		return 0
	else
		return 1
	fi
}

add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
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
		sed -i "/^${ESCAPED_KEY}=/s/.*/${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}/" "${FILE_PATH}"
	else
		echo "${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}" >> "${FILE_PATH}"
	fi
}

function dialog_yes_no(){
	if [ "$#" -ne 2 ]; then
		printf "!ERROR! Function yes_no_dialog() expects one argument\n"
		exit 1
	fi
	DIALOG_TEXT="${1}"
	VALUE_VARNAME="${2}"
	if [[ -z "${VALUE_VARNAME}" ]]; then
		printf "!ERROR! VALUE_VARNAME should not be empty\n"
		return
	fi
	while true; do
		printf "${DIALOG_TEXT} [y/n] "
		read USER_ANSWER
		case "${USER_ANSWER}" in
			[Yy]* )
				USER_ANSWER="yes"
				break
				;;
			[Nn]* )
				USER_ANSWER="no"
				break
				;;
			* )
				printf "Please answer by yes or no\n\n" > /dev/stderr
				;;
		esac
	done
	export "${VALUE_VARNAME}"="${USER_ANSWER}"
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
		echo "Function backup_file() expects BACKUP_MODE and FILE in parameters"
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
	printf "Created backup of: ${FILE}\n"
}

backup_by_rename_if_exists_and_copy_replacement(){
	if [[ $# -ne 2 ]]; then
		echo "Function backup_by_rename_if_exists_and_copy_replacement() expects SOURCE and REPLACEMENT in parameters"
		exit 1
	fi
	SOURCE="${1}"
	REPLACEMENT="${2}"
	if [[ -e "${SOURCE}" ]]; then
		backup_file rename "${SOURCE}"
	fi
	cp -r "${REPLACEMENT}" "${SOURCE}"
}

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

is_package_available(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
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
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	PACKAGE_DESCRIPTION=$(apt-cache show "${PACKAGE_NAME}"|grep -m 1 "Description-en: "|sed 's/Description-en: //g'|sed 's/^\s\+//g'|sed 's/\s\+$//g')
	printf "${PACKAGE_DESCRIPTION}"
}

generate_apt_package_list_files(){
	if [[ $# -ne 3 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_LIST_FILE, APT_PACKAGE_LIST_FILE_NAME_PREFIX and MISSING_PACKAGE_LIST_FILE in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_LIST_FILE="${1}"
	APT_PACKAGE_LIST_FILE="${2}"
	MISSING_PACKAGE_LIST_FILE="${3}"
	if [[ ! -f "${PACKAGE_LIST_FILE}" ]]; then
		printf "Cannot find PACKAGE_LIST_FILE[%s]\n" 1>&2 "${PACKAGE_LIST_FILE}"
		exit 1
	fi
	
	# Collect the packages per APT options
	# If APT_OPTIONS is specified in LINE then we creates a package list file especially for this LINE
	declare -A APT_OPTIONS_AND_PACKAGE_LIST_ARRAY
	KEY_APT_OPTIONS="00_NO_APT_APTIONS" # The prefix "00_" will ensure this package list file to be written first
	DEBUG_DEPENDENCIES_FILE="dependencies.txt"
	if [[ -f "${DEBUG_DEPENDENCIES_FILE}" ]]; then
		rm -f "${DEBUG_DEPENDENCIES_FILE}"
	fi
	while read LINE; do
		# Remove extra spaces
		LINE=$(echo "${LINE}"|awk '{$1=$1};1')
		
		# A line can contain a comment starting with the character hash '#'
		# Remove the comment part
		LINE="${LINE%%#*}"
		
		# A line can contain APT options
		APT_OPTIONS="${KEY_APT_OPTIONS}"
		if [[ "${LINE}" == @* ]]; then
			APT_OPTIONS="${LINE%@*}"
			APT_OPTIONS="${APT_OPTIONS:1}"
			LINE="${LINE##*@}"
		fi
		
		# Skip empty lines
		if [[ -z "${LINE}" ]]; then
			continue
		fi
		
		PACKAGES_LINE="${LINE}"
		
		for PACKAGE_NAME in ${PACKAGES_LINE}; do
			IS_PACKAGE_AVAILABLE=$(is_package_available "${PACKAGE_NAME}";echo $?)
			
			# Fill APT_OPTIONS_AND_PACKAGE_LIST_ARRAY or write the missing package in MISSING_PACKAGE_LIST_FILE
			if [[ ${IS_PACKAGE_AVAILABLE} -eq 0 ]]; then
				APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[${APT_OPTIONS}]+="${PACKAGE_NAME} "
			else
				printf "%s\n" "${PACKAGE_NAME}" >> "${MISSING_PACKAGE_LIST_FILE}"
			fi
			
			# Print a report in the console for PACKAGE_NAME
			INFO_AVAILABLE=$'\e[39m\e[0m'
			INFO_INSTALLATION_STATUS=$'\e[39m\e[0m'
			INFO_PACKAGE_DESCRIPTION=""
			if [[ ${IS_PACKAGE_AVAILABLE} -eq 0 ]]; then
				INFO_AVAILABLE=$'\e[92mAVAILABLE\e[0m'
				IS_PACKAGE_INSTALLED=$(is_package_installed "${PACKAGE_NAME}";echo $?)
				if [[ ${IS_PACKAGE_INSTALLED} -eq 0 ]]; then
					INFO_INSTALLATION_STATUS=$'\e[92mINSTALLED\e[0m'
				else
					INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
				fi
				INFO_PACKAGE_DESCRIPTION=$(retrieve_package_short_description "${PACKAGE_NAME}")
			else
				INFO_AVAILABLE=$'\e[91mMISSING\e[0m'
				INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
			fi
			if [[ ! -z "${INFO_PACKAGE_DESCRIPTION}" ]]; then
				INFO_PACKAGE_DESCRIPTION=": ${INFO_PACKAGE_DESCRIPTION}"
			fi
			printf "[%-25s] [%-25s] %s%s\n" "${INFO_AVAILABLE}" "${INFO_INSTALLATION_STATUS}" "${PACKAGE_NAME}" "${INFO_PACKAGE_DESCRIPTION}"
			
			# Fill DEBUG_DEPENDENCIES_FILE with dependencies of PACKAGE_NAME
			apt-cache depends "${PACKAGE_NAME}" >> "${DEBUG_DEPENDENCIES_FILE}"
		done
	done <"${PACKAGE_LIST_FILE}"
	
	# Write the package list files
	rm -f "./${APT_PACKAGE_LIST_FILE_NAME_PREFIX}*"
	APT_PACKAGE_LIST_INDEX=0
	for APT_OPTIONS in "${!APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[@]}"; do
		APT_PACKAGE_LIST_FILE="${APT_PACKAGE_LIST_FILE_NAME_PREFIX}_${APT_PACKAGE_LIST_INDEX}"
		if [[ "${APT_OPTIONS}" != "${KEY_APT_OPTIONS}" ]]; then
			printf "%s\n" "${APT_OPTIONS}" >"${APT_PACKAGE_LIST_FILE}"
		fi
		for PACKAGE_NAME in ${APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[${APT_OPTIONS}]}; do
			printf "%s\n" "${PACKAGE_NAME}" >>"${APT_PACKAGE_LIST_FILE}"
		done
		((++APT_PACKAGE_LIST_INDEX))
	done
}

is_package_installed(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
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
		printf "${FUNCNAME[0]}() expects one or several package name in argument\n" 1>&2
		exit 1
	fi
	for PACKAGE_NAME in $@; do
		if $(is_package_installed "${PACKAGE_NAME}"); then
			printf "Package is already installed: ${PACKAGE_NAME}\n"
		else
			printf "Installing package: ${PACKAGE_NAME} ...\n"
			if [[ ${EUID} -ne 0 ]]; then
				printf "Current user is not root => using sudo\n"
				sudo apt-get install -y "${PACKAGE_NAME}"
			else
				apt-get install -y "${PACKAGE_NAME}"
			fi
		fi
	done
}

remove_with_purge_package_if_installed(){
	if [[ ! $# -ge 1 ]]; then
		printf "Function remove_with_purge_package_if_installed() expects one or several package names in argument\n" 1>&2
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

key_value_retriever(){
	KEY="${1}"
	if [[ -z "${KEY}" ]]; then
		printf "ERROR: KEY should not be empty\n"
		return
	fi
	FILE="${2}"
	if [[ ! -f "${FILE}" ]]; then
		printf "ERROR: Cannot find FILE: %s\n" "${FILE}"
		return
	fi
	VALUE_VARNAME="${3}"
	if [[ -z "${VALUE_VARNAME}" ]]; then
		printf "ERROR: VALUE_VARNAME should not be empty\n"
		return
	fi
	MATCH=$(grep "^[[:space:]]*${KEY}=" "${FILE}")
	INDEX_OF_FIRST_EQUAL=$(expr index "${MATCH}" =)
	VALUE="${MATCH:${INDEX_OF_FIRST_EQUAL}}"
	VALUE="$(echo "${VALUE}" | sed "s/\r//g" )"
	export "${VALUE_VARNAME}"="${VALUE}"
}
