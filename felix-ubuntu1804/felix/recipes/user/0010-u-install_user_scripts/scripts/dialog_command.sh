#!/usr/bin/env bash

DIALOG_RETURN_CODE=$(zenity --no-wrap --question --text "${1}"; echo $?)
if [ ${DIALOG_RETURN_CODE} = 0 ]; then
	bash -c "${2}"
fi
