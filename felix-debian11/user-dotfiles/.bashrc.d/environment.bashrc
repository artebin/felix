#!/usr/bin/env bash

export TIME_STYLE=long-iso

# Make df human readable
alias df="df -h"

# Add standard math library to bc
alias bc='bc -l'

function public_ip(){
	curl ipinfo.io/ip
}
alias public_ip=public_ip

function weather(){
	# wttr.in guesses the location from the request originator if no indicated location
	curl "wttr.in/${1}"
}
alias weather=weather

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

function m3u8_to_mp4(){
	ffmpeg -i "${1}" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "${2}"
}
alias m3u8_to_mp4=m3u8_to_mp4

function remove_ssh_key_for_host(){
	HOST_ADDRESS="${1}"
	HOST_IP_ADDRESS=$(getent hosts "${HOST_ADDRESS}" | awk '{ print $1 }')
	ssh-keygen -R "${HOST_ADDRESS}"
	ssh-keygen -R "${HOST_IP_ADDRESS}"
}
alias remove_ssh_key_for_host=remove_ssh_key_for_host
