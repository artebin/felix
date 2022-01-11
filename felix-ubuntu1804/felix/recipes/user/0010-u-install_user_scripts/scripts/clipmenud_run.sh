#!/usr/bin/env bash

# Kill all running instances of clipmenud
kill $(ps -u|grep 'bash /usr/bin/clipmenud'|awk '{print $2}') 2>/dev/null
kill $(ps -u|grep 'clipnotify'|awk '{print $2}') 2>/dev/null

#~ # Take ownership of the clipboard
export CM_OWN_CLIPBOARD=1

#~ # Manage the clipboard only
export CM_SELECTIONS="clipboard"

export CM_DEBUG=1

if (( "${CM_DEBUG}" )); then
	nohup clipmenud &
else
	nohup clipmenud >"${HOME}/clipmenud.log" 2>&1 &
fi
