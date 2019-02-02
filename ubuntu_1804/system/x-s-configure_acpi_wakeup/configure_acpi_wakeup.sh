#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

extract_acpi_dsdt(){
	echo "Extracting ACPI DSDT table ..."
	
	# ACPI Advanced Configuration and Power Interface
	# DSDT Differentiated System Description Table
	
	cd ${BASEDIR}
	install_package_if_not_installed "acpica-tools"
	cat /sys/firmware/acpi/tables/DSDT > dsdt.dat
	
	# Decompile the table with the Intel's ASL compiler
	iasl -d dsdt.dat
}

disable_all_acpi_wakeup_except_for_platform_subsystems(){
	echo "Disable all ACPI wakeup except for SUBSYSTEM[platform] ..."
	
	cd ${BASEDIR}
	ACPI_WAKEUP_FILE_NAME="acpi_wakeup.rules"
	if [[ -f "${ACPI_WAKEUP_FILE_NAME}" ]]; then
		rm -f "${ACPI_WAKEUP_FILE_NAME}"
	fi
	
	DEVICE_LINE_REGEX="^([0-9a-zA-Z]+)\s+([0-9a-zA-Z]+)\s+(.*[enabled|disabled])\s+([0-9a-ZA-Z:.]+)$"
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
			
			if [[ "${SUBSYSTEM}" == "platform" ]]; then
				continue
			fi
			
			echo "DEVICE[${DEVICE}] S_STATE[${S_STATE}] STATUS[${STATUS}] SYSFS_NODE[${SYSFS_NODE}] SUBSYSTEM=[${SUBSYSTEM}] KERNEL[${KERNEL}]"
			
			echo "# Disable DEVICE[${DEVICE}] from S_STATE[${S_STATE}]" >> "${ACPI_WAKEUP_FILE_NAME}"
			echo "SUBSYSTEM==\"${SUBSYSTEM}\", KERNEL==\"${KERNEL}\", ATTR{power/wakeup}=\"disabled\"" >> "${ACPI_WAKEUP_FILE_NAME}"
			echo "" >> "${ACPI_WAKEUP_FILE_NAME}"
		fi
	done < /proc/acpi/wakeup
	
	cp acpi_wakeup.rules /etc/udev/rules.d/90-acpi_wakeup.rules
	
	# Cleaning
	cd ${BASEDIR}
	rm -f dsdt.dat
	rm -f acpi_wakeup.rules
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
extract_acpi_dsdt 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
disable_all_acpi_wakeup_except_for_platform_subsystems 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
