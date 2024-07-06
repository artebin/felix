#!/usr/bin/env bash

# Start fdpowermon only if we are not running in a virtual machine and if we can find a battery with upower
RUNNING_IN_VIRTUAL_MACHINE=$(systemd-detect-virt)
BATTERY_INFO=$(upower -e|grep 'BAT')

if [[ -z "${RUNNING_IN_VIRTUAL_MACHINE}" || "${RUNNING_IN_VIRTUAL_MACHINE,,}" == "none" ]] && [[ ! -z "${BATTERY_INFO}" ]]; then
	fdpowermon &
else
	printf "fdpowermon_run.sh: not starting fdpowermon RUNNING_IN_VIRTUAL_MACHINE[%s] BATTERY_INFO[%s]\n" "${RUNNING_IN_VIRTUAL_MACHINE}" "${BATTERY_INFO}"
fi
