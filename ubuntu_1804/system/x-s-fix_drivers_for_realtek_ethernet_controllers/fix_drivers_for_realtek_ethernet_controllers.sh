#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

fix_drivers_for_realtek_ethernet_controllers(){
	echo "Fixing drivers r8168/r8169 for realtek ethernet controllers ..."
	
	# The command below prints the devices and the drivers that are currently used
	lspci -k -nn | grep -A 3 -i net
	
	# Install r8168-dkms
	install_package_if_not_installed "r8168-dkms"
	
	# Blacklist r8169
	backup_file copy /etc/modprobe.d/blacklist.conf
	add_or_update_line_based_on_prefix "^blacklist r8169$" "blacklist r8169" /etc/modprobe.d/blacklist.conf
	
	# Re-generate initramfs image
	update-initramfs -u
	
	# Remove r8169 and insert r8168
	modprobe -r r8169
	modprobe r8168
	
	# Add service for unloading the driver before suspend
	cp r8168_fix_before_suspend.service /etc/systemd/system
	systemctl enable r8168_fix_before_suspend.service
	
	# Add sevice for loading the driver after suspend
	cp r8168_fix_after_suspend.service /etc/systemd/system
	systemctl enable r8168_fix_after_suspend.service
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
fix_drivers_for_realtek_ethernet_controllers 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
