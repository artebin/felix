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

is_bash(){
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

retrieve_absolute_path(){
	# The 'readlink' command can not be used on Mac platform to retrieve the absolute path of the current script.
	# Internet says there's no simple way to do this and we have to invoke perl.
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
	if grep -q "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
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
