#!/usr/bin/env bash

BATTERY_INFO=$(upower -e|grep 'BAT')
if [[ ! -z "${BATTERY_INFO}" ]]; then
	fdpowermon &
fi
