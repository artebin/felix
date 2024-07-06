#!/usr/bin/env

SYS_CLASS_BAT0_DIRECTORY="/sys/class/power_supply/BAT0"

if [[ ! -d "${SYS_CLASS_BAT0_DIRECTORY}" ]]; then
	printf "!ERROR! Cannot find ${SYS_CLASS_BAT0_DIRECTORY}\n"
	exit 1
fi

printf "${SYS_CLASS_BAT0_DIRECTORY}\n"

TIMESTAMP="$(date +"%Y-%m-%dT%H-%M-%S" )"
printf "TIMESTAMP: %s\n" "${TIMESTAMP}"

BAT0_STATUS="$(cat "${SYS_CLASS_BAT0_DIRECTORY}"/status)"
printf "STATUS: %s\n" "${BAT0_STATUS}"

BAT0_CAPACITY="$(cat "${SYS_CLASS_BAT0_DIRECTORY}"/capacity)"
printf "CAPACITY: %s\n" "${BAT0_CAPACITY}"

BAT0_CHARGE_NOW="$(cat "${SYS_CLASS_BAT0_DIRECTORY}"/charge_now)"
printf "CHARGE_NOW: %s\n" "${BAT0_CHARGE_NOW}"

BAT0_CHARGE_FULL="$(cat "${SYS_CLASS_BAT0_DIRECTORY}"/charge_full)"
printf "CHARGE_FULL: %s\n" "${BAT0_CHARGE_FULL}"

BAT0_CYCLE_COUNT="$(cat "${SYS_CLASS_BAT0_DIRECTORY}"/cycle_count)"
printf "CYCLE_COUNT: %s\n" "${BAT0_CYCLE_COUNT}"
