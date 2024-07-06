#!/usr/bin/env bash

mkdir -p "/tmp/${USER}"
TINT2_PID_FILE="/tmp/${USER}/tint2_pid"
TINT2_PID=""

retrieve_tint2_pid(){
	if [[ -f "${TINT2_PID_FILE}" ]]; then
		TINT2_PID=$(cat "${TINT2_PID_FILE}")
	fi
}

start_tint2(){
	tint2 &
	TINT2_PID=$!
	printf "%s" "${TINT2_PID}" >"${TINT2_PID_FILE}"
}

stop_tint2(){
	kill -15 "${TINT2_PID}"
}

toogle_tint2(){
	retrieve_tint2_pid
	if [[ -z "${TINT2_PID}" ]]; then
		start_tint2
	else
		if $(ps --pid "${TINT2_PID}" &>/dev/null); then
			stop_tint2
		else
			start_tint2
		fi
	fi
}

print_usage(){
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
	stop_tint2
	start_tint2
else
	toogle_tint2
fi
