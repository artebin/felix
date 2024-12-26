#!/usr/bin/env bash

if [[ ! -f common.sh ]]; then
	printf "Cannot find common.sh\n"
	exit 1
fi
source common.sh

print_dmi_info_bios(){
	print_section_heading "DMI information BIOS (dmidecode)"
	echo "bios-vendor: $(sudo dmidecode -s bios-vendor)"
	echo "bios-version: $(sudo dmidecode -s bios-version)"
	echo "bios-release-date: $(sudo dmidecode -s bios-release-date)"
	print_section_ending
}

print_dmi_info_system(){
	print_section_heading "DMI information System (dmidecode)"
	echo "system-manufacturer: $(sudo dmidecode -s system-manufacturer)"
	echo "system-product-name: $(sudo dmidecode -s system-product-name)"
	echo "system-version: $(sudo dmidecode -s system-version)"
	print_section_ending
}

print_dmi_info_memory(){
	print_section_heading "DMI table decoder (dmidecode)"
	sudo dmidecode
	print_section_ending
}

print_hardware_info_inxi(){
	print_section_heading "Hardware information (inxi -Fxz)"
	inxi -Fxz
	print_section_ending
}

print_display_info_xrandr(){
	print_section_heading "Display information (xrandr --current)"
	xrandr --current
	print_section_ending
}

print_lsb_release(){
	print_section_heading "LSB release (lsb_release -a)"
	lsb_release -a
	print_section_ending
}

print_video_card_model_and_driver(){
	print_section_heading "Video card model and driver"
	lspci -k | grep -EA3 'VGA|3D|Display' 
	print_section_ending
}

print_linux_kernel_version(){
	print_section_heading "Linux Kernel Version"
	cat /proc/version
	print_section_ending
}

print_memory_info(){
	print_section_heading "Memory info (cat /proc/meminfo)"
	cat /proc/meminfo
	print_section_ending
}

print_free_memory(){
	print_section_heading "Free memory (free -m)"
	free -m
	print_section_ending
}

print_swap_information(){
	print_section_heading "Swap information (cat /proc/swaps)"
	cat /proc/swaps
	print_section_ending
}

print_temperature_sensors(){
	print_section_heading "Temperature sensors (sensors)"
	sensors
	print_section_ending
}

print_gtk_version(){
	print_section_heading "GTK+ version (dpkg -l libgtk2.0-0 libgtk-3-0)"
	dpkg -l libgtk2.0-0 libgtk-3-0
	print_section_ending
}

print_key_codes(){
	print_section_heading "Key codes (xmodmap -pke)"
	xmodmap -pke
	print_section_ending
}

extract_installed_packages_list(){
	OUTPUT_DIRECTORY="${1}"
	
	INSTALLED_PACKAGE_LIST=$(dpkg -l)
	printf "%s\n" "${INSTALLED_PACKAGE_LIST}" >"${OUTPUT_DIRECTORY}/dpkg.installed.packages.list"
	
	INSTALLED_PACKAGE_LIST=$(find /var/log -mindepth 1 -maxdepth 1 -name dpkg.log*|sort|xargs zgrep -E '( installed | remove )'|uniq)
	printf "%s\n" "${INSTALLED_PACKAGE_LIST}" >"${OUTPUT_DIRECTORY}/dpkglogs.list"
}

print_all(){
	print_dmi_info_bios
	print_dmi_info_system
	print_hardware_info_inxi
	print_display_info_xrandr
	print_lsb_release
	print_linux_kernel_version
	print_memory_info
	print_free_memory
	print_swap_information
	print_temperature_sensors
	print_gtk_version
	print_key_codes
}

REPORT_NAME="hardware_software_report_${HOSTNAME}_$(date -u +'%y%m%d-%H%M%S')"
mkdir "${REPORT_NAME}"
print_all 2>&1|remove_terminal_control_sequences >"${REPORT_NAME}/${REPORT_NAME}"
extract_installed_packages_list "${REPORT_NAME}"

chown -R "${SUDO_USER}:${SUDO_GROUP}" "${REPORT_NAME}"

printf "Report written in directory: ${REPORT_NAME}\n"
