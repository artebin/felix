#!/usr/bin/env bash

# Add standard math library to bc
alias bc='bc -l'

weather(){
	curl "wttr.in/${1}"
}
alias weather=weather

github-clone(){
	if [[ $# -eq 1 ]]; then
		git clone "${1}"
	elif [[ $# -eq 2 ]]; then
		git clone "https://github.com/${1}/${2}"
	else 
		printf "usage: github-clone [repository URL]\n"
		printf "       github-clone [user name] [project name]\n"
	fi
}
alias github-clone=github-clone

git-config-global-user-name-email(){
	git config --global user.name "${1}"
	git config --global user.email "${2}"
}
alias git-config-global-user-name-email=git-config-global-user-name-email

datetime2seconds(){
	date -d "${1}" %s
}
alias datetime2seconds=datetime2seconds

dates_diff(){
	LEFT_DATE_IN_SECONDS=$(date -d "${1}" +%s)
	RIGHT_DATE_IN_SECONDS=$(date -d "${2}" +%s)
	DIFF_IN_SECONDS=$(( ${RIGHT_DATE_IN_SECONDS} - ${LEFT_DATE_IN_SECONDS} ))
	DAY_COUNT=$(( ${DIFF_IN_SECONDS} / 86400 ))
	SECONDS_FROM_MIDNIGHT_COUNT=$(( ${DIFF_IN_SECONDS} % 86400  ))
	TIME_OF_DAY=$(date -u -d @"${DIFF_IN_SECONDS}" +"%T")
	echo "${DAY_COUNT}d ${TIME_OF_DAY}"
}
alias dates_diff=dates_diff

backup_file(){
	if [ "$#" -ne 2 ]; then
		echo "Usage: backup_file mode path"
		echo "  arguments:"
		echo "    mode\t\t'rename' or 'copy'"
		exit 1
	fi
	MODE="${1}"
	FILE_TO_BACKUP="${2}"
	if [ ! -e "${FILE_TO_BACKUP}" ]; then
		echo "Can not find ${FILE_TO_BACKUP}"
		exit 1
	fi
	FILE_BACKUP="${FILE_TO_BACKUP}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${MODE}" in
		"rename")
			mv "${FILE_TO_BACKUP}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				echo "Can not backup: ${FILE_TO_BACKUP}"
				exit 1
			fi
			;;
		"copy")
			cp "${FILE_TO_BACKUP}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				echo "Can not backup: ${FILE_TO_BACKUP}"
				exit 1
			fi
			;;
		*)
			echo "Unkown mode \"${MODE}\""
			exit 1
	esac
}
alias backup_file=backup_file

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

millisToDate() {
	date -d @$(echo "${1}/1000"|bc)
}
