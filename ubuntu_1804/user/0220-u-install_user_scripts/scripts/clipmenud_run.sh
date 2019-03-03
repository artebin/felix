#!/usr/bin/env bash

# Kill all running instances of clipmenud or clipnotify
CLIPMENUD_PIDS=$(ps -C clipmenud -o pid=)
if [[ ! -z "${CLIPMENUD_PIDS}" ]]; then
	kill -9 "${CLIPMENUD_PIDS}"
fi
CLIPNOTIFY_PIDS=$(ps -C clipnotify -o pid=)
if [[ ! -z "${CLIPNOTIFY_PIDS}" ]]; then
	kill -9 "${CLIPNOTIFY_PIDS}"
fi

# Take ownership of the clipboard
export CM_OWN_CLIPBOARD=1

# Manage the clipboard only
export CM_SELECTIONS="clipboard"

export CM_DEBUG=1

clipmenud >"${HOME}/clipmenud.log" 2>&1 &
