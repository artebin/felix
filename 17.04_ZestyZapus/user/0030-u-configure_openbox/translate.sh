#!/bin/bash
SELECTED_TEXT=$(xsel -o)
TRANSLATION=$(trans -b :fr "${SELECTED_TEXT}")
notify-send --icon=info "${SELECTED_TEXT}" "${TRANSLATION}"
