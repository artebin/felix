#!/usr/bin/env bash

VLC_HOST="localhost"
VLC_PORT_NUMBER="10001"
PLAYLIST_FILE="${HOME}/vlc_playlist.txt"
readarray -t PLAYLIST_ARRAY < "${PLAYLIST_FILE}"

mkdir -p "/tmp/${USER}"
STATUS_FILE="/tmp/${USER}/toggle_play_stop_user_playlist"
VLC_PID=""
NEXT_PLAYLIST_ITEM=""

retrieve_status(){
	if [[ -f "${STATUS_FILE}" ]]; then
		VLC_PID=$(awk 'NR==1' "${STATUS_FILE}")
		NEXT_PLAYLIST_ITEM=$(awk 'NR==2' "${STATUS_FILE}")
	fi
}

start_vlc(){
	cvlc -I rc --no-rc-fake-tty --rc-host ${VLC_HOST}:${VLC_PORT_NUMBER} &
	VLC_PID=$!
	NEXT_PLAYLIST_ITEM=0
	printf "%s\n%s" "${VLC_PID}" "${NEXT_PLAYLIST_ITEM}" >"${STATUS_FILE}"
	sleep 1
}

play_next_playlist_item(){
	PLAYLIST_ITEM_NAME="${PLAYLIST_ARRAY[${NEXT_PLAYLIST_ITEM}]}"
	espeak -v fr "${PLAYLIST_ITEM_NAME}"
	PLAYLIST_ITEM_VALUE="${PLAYLIST_ARRAY[$((NEXT_PLAYLIST_ITEM + 1))]}"
	echo "add ${PLAYLIST_ITEM_VALUE}"|nc -N ${VLC_HOST} ${VLC_PORT_NUMBER}
	printf "%s\n%s" "${VLC_PID}" "$((NEXT_PLAYLIST_ITEM + 2))" >"${STATUS_FILE}"
}

stop_vlc(){
	kill -9 "${VLC_PID}"
}

toogle_play_stop(){
	ALREADY_RUNNING=false
	retrieve_status
	if [[ ! -z "${VLC_PID}" ]] && $(ps --pid "${VLC_PID}" &>/dev/null); then
		ALREADY_RUNNING=true
	fi
	if "${ALREADY_RUNNING}"; then
		stop_vlc
	else
		start_vlc
		play_next_playlist_item
	fi
}

toogle_play_stop
