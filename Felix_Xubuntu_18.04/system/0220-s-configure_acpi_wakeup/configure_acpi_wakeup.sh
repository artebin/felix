#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell
exit_if_has_not_root_privileges

# This script analyse the content of `/proc/acpi/wakeup` in order to 
# guess which acpi wakeup should  be enable or not. As a consequence the
# state of `/proc/acpi/wakeup` is important when the script is executed.
# Do not run the script multiple times in a row, neither run it when 
# `configure_acpi_wakeup.service` has been started.

# By default disable all acpi wakeup except for LID.
# In particular: disable it for mouse and keyboard.
DISABLE_ALL_EXCEPT_LID="true"

configure_acpi_wakeup(){
	cd ${BASEDIR}
	
	echo "Configure acpi wakeup ..."
	
	if [ -f /etc/systemd/system/configure_acpi_wakeup.service ]; then
		echo "/etc/systemd/system/configure_acpi_wakeup.service already exists"
		exit 1
	fi
	
	cp configure_acpi_wakeup.service.template configure_acpi_wakeup.service
	
	if [ "${DISABLE_ALL_EXCEPT_LID}" = "true" ]; then
		echo "Disabling all acpi wakeup except for LID ..."
	else
		echo "Disabling all acpi wakup ..."
	fi
	
	cat /proc/acpi/wakeup > ./acpi_wakeup
	CONFIGURE_COMMAND=""
	while read LINE; do
		if [[ ${LINE} == Device* ]]; then
			continue
		fi
		if [[ ${LINE} != [a-zA-Z0-9]* ]]; then
			continue
		fi
		DEVICE_ID=`echo "${LINE}"|cut -f1`
		STATUS=`echo "${LINE}"|cut -f3`
		
		if [[ "${LINE}" == LID* ]]; then
			if [ "${DISABLE_ALL_EXCEPT_LID}" = "true" ]; then
				if [[ "${STATUS}" == \*disabled* ]]; then
					CONFIGURE_COMMAND="echo ${DEVICE_ID} >> /proc/acpi/wakeup;${CONFIGURE_COMMAND}"
					continue
				fi
			fi
		elif [[ "${STATUS}" != \*disabled* ]]; then
			CONFIGURE_COMMAND="echo ${DEVICE_ID} >> /proc/acpi/wakeup;${CONFIGURE_COMMAND}"
		fi
		
	done < ./acpi_wakeup
	
	add_or_update_line_based_on_prefix "ExecStart" "ExecStart=/bin/bash -c \"${CONFIGURE_COMMAND}\"" ./configure_acpi_wakeup.service
	cp ./configure_acpi_wakeup.service /etc/systemd/system/configure_acpi_wakeup.service
	systemctl daemon-reload
	systemctl start configure_acpi_wakeup.service
	systemctl status configure_acpi_wakeup.service
	systemctl enable configure_acpi_wakeup.service
	
	# Cleaning
	cd ${BASEDIR}
	rm -f acpi_wakeup configure_acpi_wakeup.service
	
	echo
}

cd ${BASEDIR}

configure_acpi_wakeup 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
