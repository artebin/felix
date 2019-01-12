#!/usr/bin/env bash

DISPLAY_ID="${DISPLAY:1}"
if [ -z "${DISPLAY_ID}" ]; then
	DISPLAY_ID="nodisplay"
fi

DESKTOP_ID=`xprop -root _NET_CURRENT_DESKTOP`
DESKTOP_ID="${DESKTOP_ID##* }"

if [ ! -z "${DESKTOP_ID}" ]; then
	GEANY_SOCKET_FILE="geany-socket-${USER}-${DISPLAY_ID}-${DESKTOP_ID}"
	exec geany --socket-file "/tmp/${GEANY_SOCKET_FILE}" "$@"
else
	exec geany "$@"
fi
