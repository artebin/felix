#!/usr/bin/env bash

# Start pasystray only if we are not running in a virtual machine
RUNNING_IN_VIRTUAL_MACHINE=$(systemd-detect-virt)

if [[ -z "${RUNNING_IN_VIRTUAL_MACHINE}" || "${RUNNING_IN_VIRTUAL_MACHINE,,}" == "none" ]]; then
	pasystray --notify=sink_default --notify=source_default &
else
	printf "pasystray_run.sh: not starting pasystray RUNNING_IN_VIRTUAL_MACHINE[%s]\n" "${RUNNING_IN_VIRTUAL_MACHINE}"
fi
