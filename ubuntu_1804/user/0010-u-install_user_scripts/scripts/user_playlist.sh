#!/usr/bin/env bash

PLAYLIST_FILE="${HOME}/.user_playlist.txt"
PLAYLIST_ITEM_COUNT=0
if [[ -f "${PLAYLIST_FILE}" ]]; then
	PLAYLIST_ITEM_COUNT=$(wc -l < "${PLAYLIST_FILE}")
	readarray -t PLAYLIST_ARRAY < "${PLAYLIST_FILE}"
fi
PLAYLIST_ITEM_CURRENT_INDEX=""
PLAYLIST_ITEM_TO_PLAY_INDEX=""

VLC_HOST="localhost"
VLC_PORT_NUMBER="10001"
STATUS_FILE="/dev/shm/${USER}.user_playlist"
VLC_PID=""

retrieve_status(){
	if [[ -f "${STATUS_FILE}" ]]; then
		VLC_PID=$(awk 'NR==1' "${STATUS_FILE}")
		PLAYLIST_ITEM_CURRENT_INDEX=$(awk 'NR==2' "${STATUS_FILE}")
	fi
	if [[ ! -z "${VLC_PID}" ]] && ! $(ps --pid "${VLC_PID}" &>/dev/null); then
		VLC_PID=""
		PLAYLIST_ITEM_CURRENT_INDEX=""
	fi
	printf "VLC_PID[%s] PLAYLIST_ITEM_CURRENT_INDEX[%s]\n" "${VLC_PID}" "${PLAYLIST_ITEM_CURRENT_INDEX}"
}

start_vlc(){
	cvlc -I rc --no-rc-fake-tty --rc-host ${VLC_HOST}:${VLC_PORT_NUMBER} 0>&- 1>&- 2>&- 3>&- &
	VLC_PID=$!
	printf "%s\n%s" "${VLC_PID}" "${PLAYLIST_ITEM_CURRENT_INDEX}" >"${STATUS_FILE}"
	sleep 1
}

play_previous_playlist_item(){
	if [[ -z "${VLC_PID}" ]]; then
		printf "Playback is not running\n"
		exit 1
	fi
	if [[ "${PLAYLIST_ITEM_COUNT}" -eq 1 ]]; then
		printf "Nothing previous PLAYLIST_ITEM_COUNT[%s]\n"
		exit 1
	fi
	if [[ -z "${PLAYLIST_ITEM_CURRENT_INDEX}" ]]; then
		PLAYLIST_ITEM_TO_PLAY_INDEX=$((PLAYLIST_ITEM_COUNT - 2))
	else
		PLAYLIST_ITEM_TO_PLAY_INDEX=$((PLAYLIST_ITEM_CURRENT_INDEX - 2))
	fi
	PLAYLIST_ITEM_TO_PLAY_INDEX=$((PLAYLIST_ITEM_TO_PLAY_INDEX % PLAYLIST_ITEM_COUNT))
	play_playlist_item
}

play_next_playlist_item(){
	if [[ -z "${VLC_PID}" ]]; then
		printf "Playback is not running\n"
		exit 1
	fi
	if [[ "${PLAYLIST_ITEM_COUNT}" -eq 1 ]]; then
		printf "Nothing next PLAYLIST_ITEM_COUNT[%s]\n"
		exit 1
	fi
	if [[ -z "${PLAYLIST_ITEM_CURRENT_INDEX}" ]]; then
		PLAYLIST_ITEM_TO_PLAY_INDEX="0"
	else
		PLAYLIST_ITEM_TO_PLAY_INDEX=$((PLAYLIST_ITEM_CURRENT_INDEX + 2))
	fi
	PLAYLIST_ITEM_TO_PLAY_INDEX=$((PLAYLIST_ITEM_TO_PLAY_INDEX % PLAYLIST_ITEM_COUNT))
	play_playlist_item
}

play_playlist_item(){
	if [[ -z "${PLAYLIST_ITEM_TO_PLAY_INDEX}" ]]; then
		printf "ERROR: unexpected value for PLAYLIST_ITEM_TO_PLAY_INDEX[%s]\n" "${PLAYLIST_ITEM_TO_PLAY_INDEX}"
		exit 1
	fi
	PLAYLIST_ITEM_TO_PLAY_NAME="${PLAYLIST_ARRAY[${PLAYLIST_ITEM_TO_PLAY_INDEX}]}"
	PLAYLIST_ITEM_TO_PLAY_VALUE="${PLAYLIST_ARRAY[$((PLAYLIST_ITEM_TO_PLAY_INDEX + 1))]}"
	espeak -v fr "${PLAYLIST_ITEM_TO_PLAY_NAME}"
	echo "add ${PLAYLIST_ITEM_TO_PLAY_VALUE}" | nc -N ${VLC_HOST} ${VLC_PORT_NUMBER}
	printf "%s\n%s" "${VLC_PID}" "${PLAYLIST_ITEM_TO_PLAY_INDEX}" >"${STATUS_FILE}"
}

stop_vlc(){
	kill -9 "${VLC_PID}"
}

toggle_play_stop(){
	if [[ ! -z "${VLC_PID}" ]]; then
		stop_vlc
	else
		start_vlc
		PLAYLIST_ITEM_TO_PLAY_INDEX="0"
		play_playlist_item
	fi
}

retrieve_status
COMMAND="${1}"
case "${COMMAND}" in
	toggle)
		toggle_play_stop
		;;
	previous)
		echo "pause" | nc -N ${VLC_HOST} ${VLC_PORT_NUMBER}
		play_previous_playlist_item
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
