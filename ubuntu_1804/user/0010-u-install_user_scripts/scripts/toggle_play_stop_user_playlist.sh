#!/usr/bin/env bash

VLC_HOST="localhost"
VLC_PORT_NUMBER="10001"
PLAYLIST_FILE="${HOME}/.user_playlist.txt"
PLAYLIST_ITEM_COUNT=0
if [[ -f "${PLAYLIST_FILE}" ]]; then
	PLAYLIST_ITEM_COUNT=$(wc -l < "${PLAYLIST_FILE}")
	readarray -t PLAYLIST_ARRAY < "${PLAYLIST_FILE}"
fi

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
	nohup cvlc -I rc --no-rc-fake-tty --rc-host ${VLC_HOST}:${VLC_PORT_NUMBER} >/dev/null 2>/dev/null </dev/null &
	VLC_PID=$!
	NEXT_PLAYLIST_ITEM=0
	printf "%s\n%s" "${VLC_PID}" "${NEXT_PLAYLIST_ITEM}" >"${STATUS_FILE}"
	sleep 1
}

play_next_playlist_item(){
	retrieve_status
	
	PLAYLIST_ITEM_NAME="${PLAYLIST_ARRAY[${NEXT_PLAYLIST_ITEM}]}"
	espeak -v fr "${PLAYLIST_ITEM_NAME}"
	PLAYLIST_ITEM_VALUE="${PLAYLIST_ARRAY[$((NEXT_PLAYLIST_ITEM + 1))]}"
	echo "add ${PLAYLIST_ITEM_VALUE}" | nc -N ${VLC_HOST} ${VLC_PORT_NUMBER}
	
	NEXT_PLAYLIST_ITEM=$((NEXT_PLAYLIST_ITEM + 2))
	NEXT_PLAYLIST_ITEM=$((NEXT_PLAYLIST_ITEM % PLAYLIST_ITEM_COUNT))
	printf "%s\n%s" "${VLC_PID}" "${NEXT_PLAYLIST_ITEM}" >"${STATUS_FILE}"
}

stop_vlc(){
	kill -9 "${VLC_PID}"
}

toggle_play_stop(){
	if [[ "${PLAYLIST_ITEM_COUNT}" == 0 ]]; then
		printf "Playlist file is empty => nothing to do!\n"
		exit 0
	fi
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

COMMAND="${1}"
case "${COMMAND}" in
	toggle)
		toggle_play_stop
		;;
	next)
		echo "pause" | nc -N ${VLC_HOST} ${VLC_PORT_NUMBER}
		play_next_playlist_item
		;;
	*)
		printf "Unsupported command: ${COMMAND}\n"
		exit 1
		;;
esac
