#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_acpi_wakeup(){
	cd ${BASEDIR}
	
	echo "Configure acpi wakeup ..."
	if [ -f /etc/systemd/system/configure_acpi_wakeup.service ]; then
		echo "/etc/systemd/system/configure_acpi_wakeup.service already exists"
		exit 1
	fi
	
	# Disable everything except LID
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
			if [[ "${STATUS}" == \*disabled* ]]; then
				CONFIGURE_COMMAND="echo ${DEVICE_ID} >> /proc/acpi/wakeup;${CONFIGURE_COMMAND}"
				continue
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
}

cd ${BASEDIR}
configure_acpi_wakeup 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
