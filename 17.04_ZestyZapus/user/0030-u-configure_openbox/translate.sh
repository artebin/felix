#!/bin/bash

SELECTED_TEXT=$(xsel -o)
if [ -z "${SELECTED_TEXT}" ]; then
	exit 0
fi

TRANSLATION=$(trans -b :fr "${SELECTED_TEXT}")
NOTIFICATION_TEXT="${SELECTED_TEXT}\n\n<i>${TRANSLATION}</i>"

# Desktop Notifications Specification <http://www.galago-project.org/specs/notification/0.9/x161.html>
notify-send --icon=info "Translation" "${NOTIFICATION_TEXT}"
