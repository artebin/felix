#!/usr/bin/env bash

# Make df human readable
alias df='df -h'

# Add standard math library to bc
alias bc='bc -l'

# Show file system labels in lsblk output
alias lsblk='lsblk -o name,mountpoint,label,size,uuid'

# Always colorize grep output
alias grep='grep --color=always'

function backup_file(){
	BACKUP_MODE="${1}"
	FILE="${2}"
	if [[ "${BACKUP_MODE}" != "-r"  && "${BACKUP_MODE}" != "-c" ]]; then
		printf "Usage: %s [-r | -c] FILE\n" "${FUNCNAME[0]}"
		return
	fi
	if [[ -z "${FILE}" || ! -e "${FILE}" ]]; then
		printf "Usage: %s [-r | -c] FILE\n" "${FUNCNAME[0]}"
		return
	fi
	FILE_BACKUP="${FILE}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${BACKUP_MODE}" in
		"-r")
			mv "${FILE}" "${FILE_BACKUP}"
			if [[ "$?" -ne 0 ]]; then
				printf "!ERROR! Cannot backup: %s\n" "${FILE}"
				return
			fi
			;;
		"-c")
			cp "${FILE}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				printf "!ERROR! Cannot backup: %s\n" "${FILE}"
				return
			fi
			;;
	esac
}
alias backup_file=backup_file

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
function remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

function set_terminal_title() {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$*\a\]"
	PS1=${ORIG}${TITLE}
}
alias set_terminal_title=set_terminal_title

function remove_ssh_key_for_host(){
	HOST_ADDRESS="${1}"
	HOST_IP_ADDRESS=$(getent hosts "${HOST_ADDRESS}" | awk '{ print $1 }')
	ssh-keygen -R "${HOST_ADDRESS}"
	ssh-keygen -R "${HOST_IP_ADDRESS}"
}
alias remove_ssh_key_for_host=remove_ssh_key_for_host
