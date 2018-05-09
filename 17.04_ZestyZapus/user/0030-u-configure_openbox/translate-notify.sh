#!/bin/bash

usage(){
	printf "Usage: $0 [text to translate]\n\n"
}

SELECTED_TEXT=""

if [ "$#" -gt 1 ]; then
	usage
	exit 1
fi

if [ "$#" -eq 1 ]; then
	SELECTED_TEXT="${1}"
else
	SELECTED_TEXT=$(xsel -o)
fi

if [ -z "${SELECTED_TEXT}" ]; then
	exit 0
fi

TRANSLATION=$(trans -b :fr "${SELECTED_TEXT}")
NOTIFICATION_TEXT="${SELECTED_TEXT}\n\n<i>${TRANSLATION}</i>"

# Desktop Notifications Specification <http://www.galago-project.org/specs/notification/0.9/x161.html>
notify-send --icon=info "Translation" "${NOTIFICATION_TEXT}"
