#!/usr/bin/env bash

# Kill all running instances of clipmenud
SEARCH_PATTERN="^${USER}[[:blank:]].*[[:blank:]]/usr/bin/clipmenud$"
while read LINE; do
	PID=$(echo ${LINE}|cut -d ' ' -f2)
	kill -9 "${PID}"
done < <(ps -u "${USER}"|grep "${SEARCH_PATTERN}")

# Take ownership of the clipboard
export CM_OWN_CLIPBOARD=1

# Manage the clipboard only
export CM_SELECTIONS=( "clipboard" )

export CM_DEBUG=1

clipmenud >"${HOME}/clipmenud.log" 2>&1 &
