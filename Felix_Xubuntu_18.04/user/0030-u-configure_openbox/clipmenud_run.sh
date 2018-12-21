#!/usr/bin/env bash

SEARCH_PATTERN="^${USER}[[:blank:]].*[[:blank:]]/usr/bin/clipmenud$"

while read LINE; do
	PID=$(echo ${LINE}|cut -d ' ' -f2)
	kill -9 "${PID}"
done < <(ps -aux | grep "${SEARCH_PATTERN}")

/usr/bin/clipmenud &
