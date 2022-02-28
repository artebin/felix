#!/usr/bin/env bash

print_usage(){
	printf "Usage: $0 [-c] [-s] [-t TEXT_TO_TRANSLATE]\n"
	printf "Some dependencies are required to extract the text to translate from a screenshot: tesseract-ocr imagemagick scrot\n\n"
}

exit_gracefully(){
	# Delete files created while retrieving the text from a screenshot
	rm -f ~/.$0.*.png
	rm -f ~/.$0.*.png.txt
}
trap exit_gracefully EXIT

RETRIEVE_TEXT_FROM_CLIPBOARD="false"
RETRIEVE_TEXT_FROM_SCREENSHOT="false"
SCREENSHOT_FILE=""
TEXT_TO_TRANSLATE=""

if [[ $# -eq 0 ]]; then
	print_usage
	exit 1
fi

while getopts "cst:" OPT; do
	case "${OPT}" in
		c)
			RETRIEVE_TEXT_FROM_CLIPBOARD="true"
			;;
		s)
			RETRIEVE_TEXT_FROM_SCREENSHOT="true"
			;;
		t)
			TEXT_TO_TRANSLATE="${OPTARG}"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done

if ${RETRIEVE_TEXT_FROM_CLIPBOARD}; then
	TEXT_TO_TRANSLATE=$(xsel -o)
elif ${RETRIEVE_TEXT_FROM_SCREENSHOT}; then
	# Take the screenshot with the mouse and increase image quality with option -q from default 75 to 100
	SCREENSHOT_FILE="$(mktemp ~/.${0##*/}.XXXXXX.png)"
	scrot -d 1 -s "${SCREENSHOT_FILE}" -q 100
	
	# Should increase detection rate
	mogrify -modulate 100,0 -resize 400% "${SCREENSHOT_FILE}"
	
	tesseract "${SCREENSHOT_FILE}" "${SCREENSHOT_FILE}"
	TEXT_TO_TRANSLATE=$(cat "${SCREENSHOT_FILE}.txt")
fi

TEXT_TO_TRANSLATE=$(echo "${TEXT_TO_TRANSLATE}" | sed -e 's/^[^[[:print:]]]*//' | sed -e 's/[^[[:print:]]]*$//')

if [[ -z "${TEXT_TO_TRANSLATE}" ]]; then
	notify-send --icon=info "Translation" "Nothing to translate!"
	exit 0
fi

TRANSLATED_TEXT=$(trans -b :fr "${TEXT_TO_TRANSLATE}")
printf "TEXT_TO_TRANSLATE=%s=\n" "${TEXT_TO_TRANSLATE}"
printf "TRANSLATED_TEXT=%s\n" "${TRANSLATED_TEXT}"
NOTIFICATION_TEXT="${TEXT_TO_TRANSLATE}\n\n<i>${TRANSLATED_TEXT}</i>"

# Desktop Notifications Specification <http://www.galago-project.org/specs/notification/0.9/x161.html>
notify-send --icon=info "Translation" "${NOTIFICATION_TEXT}"
