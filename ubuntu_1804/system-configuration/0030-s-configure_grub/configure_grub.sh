#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_grub(){
	echo "Configuring grub ..."
	
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
	
	# Disable graphical terminal
	echo "Disable graphical terminal ..."
	sed -i "/^#GRUB_TERMINAL=/s/.*/GRUB_TERMINAL=console/" /etc/default/grub
	echo
	
	# Update kernel parameters:
	#  - add swap partition for resume from hibernate
	#  - disable the ACPI Operating System Identification function (_OSI). See <https://unix.stackexchange.com/questions/246672/how-to-set-acpi-osi-parameter-in-the-grub>
	FIRST_SWAP_PARTITION_DEVICE_NAME=$(swapon --noheadings --raw --show=NAME|head -n1)
	if [[ ! -z "${FIRST_SWAP_PARTITION_DEVICE_NAME}" ]]; then
		FIRST_SWAP_PARTITION_UUID=$(blkid -s UUID -o value ${FIRST_SWAP_PARTITION_DEVICE_NAME})
		echo "Adding swap partition for resume from hibernate: ${FIRST_SWAP_PARTITION_UUID}"
		echo "Disablingthe ACPI Operating System Identification function"
		sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=${FIRST_SWAP_PARTITION_UUID}\"/" /etc/default/grub
		echo
	fi
	
	update-grub
	
	echo
}

configure_grub 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
