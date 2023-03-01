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
	tint2 >/dev/null 2>/dev/null &
	TINT2_PID=$!
	printf "%s" "${TINT2_PID}" >"${TINT2_PID_FILE}"
}

stop_tint2(){
	kill -9 "${TINT2_PID}"
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

toogle_tint2
