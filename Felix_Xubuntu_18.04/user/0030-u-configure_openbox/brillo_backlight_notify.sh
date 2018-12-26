#!/usr/bin/env bash

print_usage(){
	echo "Usage:"
	echo
}

VARIATION_INCREMENT="INCREMENT"
VARIATION_DECREMENT="DECREMENT"
VARIATION=""
while getopts ":id" OPT; do
	case "${OPT}" in
		i)
			VARIATION="${VARIATION_INCREMENT}"
			;;
		d)
			VARIATION="${VARIATION_DECREMENT}"
			;;
		*)
			print_usage
			;;
	esac
done
shift $((OPTIND-1))

if [[ $# -ne 0 ]]; then
	print_usage
	exit 1
fi

if [[ "${VARIATION}" == "${VARIATION_INCREMENT}" ]]; then
	pkexec brillo -A 5
elif [[ "${VARIATION}" == "${VARIATION_DECREMENT}" ]]; then
	pkexec brillo -U 5
else
	echo "Illegal value for VARIATION: ${VARIATION}"
	exit 1
fi

BRIGHTNESS_VALUE=$(brillo -G)
BRIGHTNESS_VALUE=$(printf "%.0f\n" "${BRIGHTNESS_VALUE}")

NOTIFICATION_ID_FILE="/tmp/brillo_backlight_notification_id"
if [[ -f "${NOTIFICATION_ID_FILE}" ]]; then
	NOTIFICATION_ID=$(head -n 1 "${NOTIFICATION_ID_FILE}")
fi

if [[ -z "${NOTIFICATION_ID}" ]]; then
	NOTIFICATION_ID=$(notify-send "Display brightness" -i display-brightness -h int:value:"${BRIGHTNESS_VALUE}" -p)
	echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
else
	NOTIFICATION_ID=$(notify-send "Display brightness" -i display-brightness -h int:value:"${BRIGHTNESS_VALUE}" -p -r "${NOTIFICATION_ID}")
	echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
fi
