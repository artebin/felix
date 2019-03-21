#!/usr/bin/env bash

print_usage(){
	printf "Usage: ${0} [OPTIONS...]"
	printf "\n"
	printf "  -o mute output\n"
	printf "  -d decrease output volume\n"
	printf "  -i increase output volume\n"
	printf "  -m mute input\n"
	printf "  -n notification ID file\n"
	printf "\n"
}

COMMAND_MUTE_OUTPUT="COMMAND_MUTE_OUTPUT"
COMMAND_DECREASE_OUTPUT_VOLUME="COMMAND_DECREASE_OUTPUT_VOLUME"
COMMAND_INCREASE_OUTPUT_VOLUME="COMMAND_INCREASE_OUTPUT_VOLUME"
COMMAND_MUTE_INPUT="COMMAND_MUTE_INPUT"

COMMAND=""
NOTIFICATION_ID_FILE=""
while getopts "odimn:" OPT; do
	case "${OPT}" in
		o)
			COMMAND="${COMMAND_MUTE_OUTPUT}"
			;;
		d)
			COMMAND="${COMMAND_DECREASE_OUTPUT_VOLUME}"
			;;
		i)
			COMMAND="${COMMAND_INCREASE_OUTPUT_VOLUME}"
			;;
		m)
			COMMAND="${COMMAND_MUTE_INPUT}"
			;;
		n)
			NOTIFICATION_ID_FILE="${OPTARG}"
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

NOTIFICATION_ID=""
if [[ ! -z "${NOTIFICATION_ID_FILE}" ]]; then
	if [[ -f "${NOTIFICATION_ID_FILE}" ]]; then
		NOTIFICATION_ID=$(head -n 1 "${NOTIFICATION_ID_FILE}")
	else
		printf "Cannot find NOTIFICATION_ID_FILE: ${NOTIFICATION_ID_FILE}"
		exit 1
	fi
fi

mute_output(){
	NOTIFICATION_ID="${1}"
	
	# Retrieve mute status and retrieve icon to use
	STATUS=$(pulseaudio-ctl full-status)
	VOLUME_VALUE="$(echo "${STATUS}"|cut -d ' ' -f 1)"
	IS_MUTED="$(echo ${STATUS}|cut -d ' ' -f 2)"
	
	ICON="audio-volume-muted"
	if [[  "${IS_MUTED}" == "yes" ]]; then
		ICON="$(retrieve_icon_for_volume_value ${VOLUME_VALUE})"
	fi
	
	pulseaudio-ctl mute
	
	if [[ -z "${NOTIFICATION_ID}" ]]; then
		NOTIFICATION_ID=$(notify-send "Output Volume" -i ${ICON} -h int:value:${VOLUME_VALUE} -p)
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	else
		NOTIFICATION_ID=$(notify-send "Output Volume" -i ${ICON} -h int:value:${VOLUME_VALUE} -p -r "${NOTIFICATION_ID}")
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	fi
}

retrieve_icon_for_volume_value(){
	if [[ $# -ne 1 ]]; then
		printf "Function retrieve_icon_for_volume_value() expects VOLUME_VALUE in parameter\n"
		exit 1
	fi
	local VOLUME_VALUE="${1}"
	ICON="audio-volume-high"
	if [[ "${VOLUME_VALUE}" -lt 66 ]]; then
		ICON="audio-volume-medium"
	fi
	if [[ "${VOLUME_VALUE}" -lt 33 ]]; then
		ICON="audio-volume-low"
	fi
	printf "${ICON}"
}

variate_output_volume(){
	if [[ ! $# -ge 1 ]]; then
		printf "Function variate_output_volume() expects MODE in parameter\n"
		exit 1
	fi
	MODE="${1}"
	if ! [[  "${MODE}" == "DECREASE" || "${MODE}" == "INCREASE" ]]; then
		printf "Function variate_output_volume() expects MODE to be valued DECREASE or INCREASE\n"
		exit 1
	fi
	NOTIFICATION_ID="${2}"
	
	# Retrieve volume value
	VOLUME_VALUE=$(pulseaudio-ctl current)
	VOLUME_VALUE="${VOLUME_VALUE%"%"}"
	
	if [[ "${MODE}" == "DECREASE" ]]; then
		if [[ "${VOLUME_VALUE}" -gt 5 ]]; then
			pulseaudio-ctl down 5
			VOLUME_VALUE=$(pulseaudio-ctl current)
			VOLUME_VALUE="${VOLUME_VALUE%"%"}"
		elif [[ "${VOLUME_VALUE}" -ne 0 ]]; then
			pulseaudio-ctl set 0
			VOLUME_VALUE=0
		fi
	elif [[ "${MODE}" == "INCREASE" ]]; then
		if [[ "${VOLUME_VALUE}" -lt 95 ]]; then
			pulseaudio-ctl up 5
			VOLUME_VALUE=$(pulseaudio-ctl current)
			VOLUME_VALUE="${VOLUME_VALUE%"%"}"
		elif [[ "${VOLUME_VALUE}" -ne 100 ]]; then
			pulseaudio-ctl set 100
			VOLUME_VALUE=100
		fi
	else
		echo "Unknown MODE: ${MODE}"
		exit 1
	fi
	
	ICON="$(retrieve_icon_for_volume_value ${VOLUME_VALUE})"
	
	if [[ -z "${NOTIFICATION_ID}" ]]; then
		NOTIFICATION_ID=$(notify-send "Output Volume" -i ${ICON} -h int:value:"${VOLUME_VALUE}" -p)
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	else
		NOTIFICATION_ID=$(notify-send "Output Volume" -i ${ICON} -h int:value:"${VOLUME_VALUE}" -p -r "${NOTIFICATION_ID}")
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	fi
}

mute_input(){
	NOTIFICATION_ID="${1}"
	
	# Retrieve mute status and retrieve icon to use
	STATUS=$(pulseaudio-ctl full-status)
	IS_MUTED="$(echo ${STATUS}|cut -d ' ' -f 3)"
	
	ICON="microphone-sensitivity-muted"
	if [[  "${IS_MUTED}" == "yes" ]]; then
		ICON="$(retrieve_icon_for_volume_value ${VOLUME_VALUE})"
	fi
	
	pulseaudio-ctl mute
	
	if [[ -z "${NOTIFICATION_ID}" ]]; then
		NOTIFICATION_ID=$(notify-send "Input Volume" -i ${ICON} -h int:value:${VOLUME_VALUE} -p)
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	else
		NOTIFICATION_ID=$(notify-send "Input Volume" -i ${ICON} -h int:value:${VOLUME_VALUE} -p -r "${NOTIFICATION_ID}")
		echo "${NOTIFICATION_ID}" > "${NOTIFICATION_ID_FILE}"
	fi
}

case "${COMMAND}" in
	"${COMMAND_MUTE_OUTPUT}")
		printf "COMMAND_MUTE_OUTPUT\n"
		mute_output "${NOTIFICATION_ID}"
		;;
	"${COMMAND_DECREASE_OUTPUT_VOLUME}")
		printf "COMMAND_DECREASE_OUTPUT_VOLUME\n"
		variate_output_volume "DECREASE" "${NOTIFICATION_ID}"
		;;
	"${COMMAND_INCREASE_OUTPUT_VOLUME}")
		printf "COMMAND_INCREASE_OUTPUT_VOLUME\n"
		variate_output_volume "INCREASE" "${NOTIFICATION_ID}"
		;;
	"${COMMAND_MUTE_INPUT}")
		printf "COMMAND_MUTE_INPUT\n"
		mute_output "${NOTIFICATION_ID}"
		;;
	*)
		printf "Unknown COMMAND: ${COMMAND}\n"
		exit 1
		;;
esac
