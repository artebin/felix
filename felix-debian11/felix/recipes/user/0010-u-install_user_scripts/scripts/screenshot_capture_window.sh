#!/usr/bin/env bash

usage(){
	printf "USAGE: ${0} [OPTIONS...]...\n"
	printf "OPTIONS:\n"
	printf "  -f\tinclude the window frame in the screenshot\n"
}

INCLUDE_WINDOW_FRAME="false"
SCREENSHOTS_DIRECTORY="/${HOME}/Screenshots"

# Create SCREENSHOTS_DIRECTORY if it does not exist
if [[ ! -d "${SCREENSHOTS_DIRECTORY}" ]]; then
	mkdir "${SCREENSHOTS_DIRECTORY}"
fi

while getopts ":f" OPT; do
	case "${OPT}" in
		f)
			INCLUDE_WINDOW_FRAME="true"
			;;
	*)
		usage
		exit 1
		;;
	esac
done
shift $((OPTIND-1))

SCREENSHOT_XWD_FILE="${SCREENSHOTS_DIRECTORY}/Screenshot_$(date -u +'%y%m%d-%H%M%S').xwd"
SCREENSHOT_PNG_FILE="${SCREENSHOTS_DIRECTORY}/Screenshot_$(date -u +'%y%m%d-%H%M%S').png"

if ${INCLUDE_WINDOW_FRAME}; then
	xwd -frame >"${SCREENSHOT_XWD_FILE}"
else
	xwd >"${SCREENSHOT_XWD_FILE}"
fi
convert "${SCREENSHOT_XWD_FILE}" "${SCREENSHOT_PNG_FILE}"
rm "${SCREENSHOT_XWD_FILE}"
