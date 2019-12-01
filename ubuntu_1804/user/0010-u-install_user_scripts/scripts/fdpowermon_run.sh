#!/usr/bin/env bash

# Start fdpowermon only if we can find a battery with upower

BATTERY_INFO=$(upower -e|grep 'BAT')
if [[ ! -z "${BATTERY_INFO}" ]]; then
	fdpowermon &
else
	printf "Cannot find battery information using upower\n"
fi
