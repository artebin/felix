#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

extract_acpi_dsdt(){
	printf "Extracting ACPI DSDT table...\n"
	
	# ACPI Advanced Configuration and Power Interface
	# DSDT Differentiated System Description Table
	
	install_package_if_not_installed "acpica-tools"
	
	cd "${RECIPE_DIRECTORY}"
	cat /sys/firmware/acpi/tables/DSDT > dsdt.dat
	
	# Decompile the table with the Intel's ASL compiler
	iasl -d dsdt.dat
	
	printf "\n"
}

disable_all_acpi_wakeup_except_for_platform_subsystems(){
	printf "Disabling all ACPI wakeup except for SUBSYSTEM[platform]...\n"
	
	cd "${RECIPE_DIRECTORY}"
	ACPI_WAKEUP_FILE_NAME="acpi_wakeup.rules"
	if [[ -f "${ACPI_WAKEUP_FILE_NAME}" ]]; then
		rm -f "${ACPI_WAKEUP_FILE_NAME}"
	fi
	
	DEVICE_LINE_REGEX="^([0-9a-zA-Z]+)\s+([0-9a-zA-Z]+)\s+(.*[enabled|disabled])\s+(.+)$"
	while read -r LINE; do
		if [[ "${LINE}" =~ ^Device ]]; then
			continue
		fi
		if [[ "${LINE}" =~ ${DEVICE_LINE_REGEX} ]]; then
			DEVICE="${BASH_REMATCH[1]}"
			S_STATE="${BASH_REMATCH[2]}"
			STATUS="${BASH_REMATCH[3]}"
			SYSFS_NODE="${BASH_REMATCH[4]}"
			SUBSYSTEM="${SYSFS_NODE%%:*}"
			KERNEL="${SYSFS_NODE#*:}"
			
			ATTR_VALUE="${STATUS:1}"
			if [[ "${SUBSYSTEM}" != "platform" ]]; then
				ATTR_VALUE="disabled"
			fi
			
			printf "DEVICE[${DEVICE}] S_STATE[${S_STATE}] STATUS[${STATUS}] SYSFS_NODE[${SYSFS_NODE}] SUBSYSTEM=[${SUBSYSTEM}] KERNEL[${KERNEL}]\n"
			
			printf "# Disable DEVICE[${DEVICE}] from S_STATE[${S_STATE}]\n" >> "${ACPI_WAKEUP_FILE_NAME}"
			printf "SUBSYSTEM==\"${SUBSYSTEM}\", KERNEL==\"${KERNEL}\", ATTR{power/wakeup}=\"${ATTR_VALUE}\"\n" >> "${ACPI_WAKEUP_FILE_NAME}"
			printf "\n" >> "${ACPI_WAKEUP_FILE_NAME}"
		fi
	done < /proc/acpi/wakeup
	
	cp "${ACPI_WAKEUP_FILE_NAME}" /etc/udev/rules.d/90-acpi_wakeup.rules
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -f dsdt.dat
	#rm -f "${ACPI_WAKEUP_FILE_NAME}"
	printf "\n"
}

extract_acpi_dsdt 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

disable_all_acpi_wakeup_except_for_platform_subsystems 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
