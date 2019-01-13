#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

configure_grub(){
	cd ${BASEDIR}
	
	# Backup grub configuration
	echo "Backup current grub configuration ..."
	backup_file copy /etc/default/grub
	echo
	
	# Show grub and set timeout
	echo "Show grub and set timeout ..."
	sed -i "/^GRUB_TIMEOUT_STYLE/s/.*/#GRUB_TIMEOUT_STYLE=/" /etc/default/grub
	sed -i "/^GRUB_TIMEOUT/s/.*/GRUB_TIMEOUT=10/" /etc/default/grub
	echo
	
	# Remove boot option 'quiet' and 'splash'
	echo "Remove boot option 'quiet' and 'splash' ..."
	sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
	echo
	
	# Update kernel parameters:
	#  - add swap partition for resume from hibernate
	#  - disable the ACPI Operating System Identification function (_OSI). See <https://unix.stackexchange.com/questions/246672/how-to-set-acpi-osi-parameter-in-the-grub>
	FIRST_SWAP_PARTITION_DEVICE_NAME=$(swapon --noheadings --raw --show=NAME|head -n1)
	FIRST_SWAP_PARTITION_UUID=$(sudo blkid -s UUID -o value ${FIRST_SWAP_PARTITION_DEVICE_NAME})
	echo "Adding swap partition for resume from hibernate: ${FIRST_SWAP_PARTITION_UUID}"
	echo "Disablingthe ACPI Operating System Identification function"
	sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=${FIRST_SWAP_PARTITION_UUID} acpi_osi=\"/" /etc/default/grub
	echo
	
	update-grub
	
	echo
}

cd ${BASEDIR}
configure_grub 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
