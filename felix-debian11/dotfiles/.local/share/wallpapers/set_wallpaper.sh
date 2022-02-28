#!/usr/bin/env bash

SCRIPT_PARENT_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"

# Start xeventbind if not already started
XEVENTBIND_PID_FILE="/tmp/${USER}/set_wallpaper_xeventbind_pid"
XEVENTBIND_PID=""
if [[ -f "${XEVENTBIND_PID_FILE}" ]]; then
	XEVENTBIND_PID=$(cat "${XEVENTBIND_PID_FILE}")
fi
if [[ -z "${XEVENTBIND_PID}" ]] && ! $(ps --pid "${XEVENTBIND_PID}" &>/dev/null); then
	xeventbind resolution "${HOME}/.local/share/wallpapers/set_wallpaper.sh" </dev/null >/dev/null 2>/dev/null &
	XEVENTBIND_PID=$!
	if [[ ! -d "/tmp/${USER}" ]]; then
		mkdir -p "/tmp/${USER}"
	fi
	printf "%s" "${XEVENTBIND_PID}" >"${XEVENTBIND_PID_FILE}"
fi

#hsetroot -solid "#303030" &
#hsetroot -tile "${SCRIPT_PARENT_DIRECTORY}/texture_0.jpg" &
hsetroot -fill "${SCRIPT_PARENT_DIRECTORY}/earth-in-space.png" &
