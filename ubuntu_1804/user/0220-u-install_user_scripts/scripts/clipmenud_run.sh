#!/usr/bin/env bash

SEARCH_PATTERN="^${USER}[[:blank:]].*[[:blank:]]/usr/bin/clipmenud$"

while read LINE; do
	PID=$(echo ${LINE}|cut -d ' ' -f2)
	kill -9 "${PID}"
done < <(ps -aux | grep "${SEARCH_PATTERN}")

# If the variable below is not set then clipmenud will consume the
# clipboard and other programs could not see clipboard content,
# i.e. no paste action would be possible
export CM_OWN_CLIPBOARD=0

/usr/bin/clipmenud &
