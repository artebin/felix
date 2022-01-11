#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_grub(){
	printf "Configuring grub...\n"
	
	# Backup grub configuration
	printf "Backup current grub configuration ...\n"
	backup_file copy /etc/default/grub
	echo
	
	# Show grub and set timeout
	printf "Showing grub and set timeout...\n"
	sed -i "/^GRUB_TIMEOUT_STYLE/s/.*/#GRUB_TIMEOUT_STYLE=/" /etc/default/grub
	sed -i "/^GRUB_TIMEOUT/s/.*/GRUB_TIMEOUT=10/" /etc/default/grub
	printf "\n"
	
	# Remove boot options 'quiet' and 'splash'
	printf "Removing boot options 'quiet' and 'splash'...\n"
	sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
	printf "\n"
	
	# Disable submenu
	printf "Disabling submenu...\n"
	add_or_update_keyvalue /etc/default/grub "GRUB_DISABLE_SUBMENU" "GRUB_DISABLE_SUBMENU=y"
	printf "\n"
	
	# Disable graphical terminal
	printf "Disabling graphical terminal...\n"
	sed -i "/^#GRUB_TERMINAL=/s/.*/GRUB_TERMINAL=console/" /etc/default/grub
	printf "\n"
	
	# Update kernel parameters:
	#  - add swap partition for resume from hibernate
	#  - use acpi_backlight=native
	
	# Before there was here a code for disabling the ACPI Operating System Identification function (OSI), but I don't think it is still needed.
	# See <https://unix.stackexchange.com/questions/246672/how-to-set-acpi-osi-parameter-in-the-grub>
	
	FIRST_SWAP_PARTITION_DEVICE_NAME=$(swapon --noheadings --raw --show=NAME|head -n1)
	if [[ ! -z "${FIRST_SWAP_PARTITION_DEVICE_NAME}" ]]; then
		FIRST_SWAP_PARTITION_UUID=$(blkid -s UUID -o value ${FIRST_SWAP_PARTITION_DEVICE_NAME})
		echo "Adding swap partition for resume from hibernate: ${FIRST_SWAP_PARTITION_UUID}"
		echo "Using acpi_backlight=native"
		sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=${FIRST_SWAP_PARTITION_UUID} acpi_backlight=native\"/" /etc/default/grub
		echo
	fi
	
	update-grub
	
	printf "\n"
}

configure_grub 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
