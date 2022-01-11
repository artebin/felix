#!/usr/bin/env bash

mkdir -p "/tmp/${USER}"
AVAHI_DISCOVER_PID_FILE="/tmp/${USER}/tint2_avahi_discover_pid"
AVAHI_DISCOVER_PID=""
AVAHI_DISCOVER_WINDOW_ID=""

retrieve_avahi_discover_window(){
	ALL_WINDOWS_ID_LIST=$(xwininfo -root -children|sed -e 's/^ *//'|grep -E "^0x"|awk '{ print $1 }')
	for WINDOW_ID in ${ALL_WINDOWS_ID_LIST}; do
		XPROP_NET_WM_PID=$(xprop -id "${WINDOW_ID}" _NET_WM_PID)
		XPROP_EXIT_CODE=$?
		if [[ ${XPROP_EXIT_CODE} -ne 0 ]]; then
			continue
		fi
		if [[ "${XPROP_NET_WM_PID}" == "_NET_WM_PID:  not found." ]]; then
			continue;
		fi
		PID=$(echo "${XPROP_NET_WM_PID}"|cut -d'=' -f2|tr -d ' ')
		if [[ "${PID}" == "${AVAHI_DISCOVER_PID}" ]]; then
			AVAHI_DISCOVER_WINDOW_ID="${WINDOW_ID}"
		fi
	done
}

retrieve_avahi_discover_pid(){
	if [[ -f "${AVAHI_DISCOVER_PID_FILE}" ]]; then
		AVAHI_DISCOVER_PID=$(cat "${AVAHI_DISCOVER_PID_FILE}")
	fi
}

start_avahi_discover(){
	avahi-discover >/dev/null 2>/dev/null &
	AVAHI_DISCOVER_PID=$!
	printf "%s" "${AVAHI_DISCOVER_PID}" >"${AVAHI_DISCOVER_PID_FILE}"
}

stop_avahi_discover(){
	kill -9 "${AVAHI_DISCOVER_PID}"
}

show_avahi_discover(){
	start_avahi_discover
}

hide_avahi_discover(){
	stop_avahi_discover
}

toogle_avahi_discover(){
	retrieve_avahi_discover_pid
	if [[ -z "${AVAHI_DISCOVER_PID}" ]]; then
		show_avahi_discover
	else
		if $(ps --pid "${AVAHI_DISCOVER_PID}" &>/dev/null); then
			hide_avahi_discover
		else
			show_avahi_discover
		fi
	fi
}

toogle_avahi_discover
