#!/usr/bin/env bash

function toogle_tint2(){
	if $(pgrep tint2 &>/dev/null); then
		pkill tint2
	else
		tint2 &
	fi
}

function print_usage(){
	printf "Usage: bash ${0} [OPTIONS...]\n"
	printf "  -r restart tint2\n"
	printf "\n"
}

# Retrieve options
RESTART="false"
while getopts ":r" OPT; do
	case "${OPT}" in
		r)
			RESTART="true"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

if "${RESTART}"; then
	pkill tint2
	sleep 1
	tint2 &
else
	toogle_tint2
fi
