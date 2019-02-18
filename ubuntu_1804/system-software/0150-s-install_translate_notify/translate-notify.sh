#!/usr/bin/env bash

usage(){
	printf "Usage: $0 [text to translate]\n\n"
}

SELECTED_TEXT=""
INPUT_IS_CLIPBOARD=""

if [ "$#" -gt 1 ]; then
	usage
	exit 1
fi

if [ "$#" -eq 1 ]; then
	INPUT_IS_CLIPBOARD="false"
	SELECTED_TEXT="${1}"
	SELECTED_TEXT=$(echo "${SELECTED_TEXT}" | sed -e 's/^[ \t]*//' | sed -e 's/[ \t]*$//')
	if [ -z "${SELECTED_TEXT}" ]; then
		notify-send --icon=info "Translation" "Nothing to translate"
		exit 0
	fi
else
	INPUT_IS_CLIPBOARD="true"
	SELECTED_TEXT=$(xsel -o)
	SELECTED_TEXT=$(echo "${SELECTED_TEXT}" | sed -e 's/^[ \t]*//' | sed -e 's/[ \t]*$//')
	if [ -z "${SELECTED_TEXT}" ]; then
		notify-send --icon=info "Translation" "Nothing to translate"
		exit 0
	fi
fi

TRANSLATION=$(trans -b :fr "${SELECTED_TEXT}")
NOTIFICATION_TEXT="${SELECTED_TEXT}\n\n<i>${TRANSLATION}</i>"

# Desktop Notifications Specification <http://www.galago-project.org/specs/notification/0.9/x161.html>
notify-send --icon=info "Translation" "${NOTIFICATION_TEXT}"
