#!/usr/bin/env bash

ACPI_OUTPUT="$(acpi -V 2>&1)"
NO_POWER_SUPPLY_REGEX="^No support for device type: power_supply$"
if [[ ! "${ACPI_OUTPUT}" =~ ${NO_POWER_SUPPLY_REGEX} ]]; then
	fdpowermon &
fi
