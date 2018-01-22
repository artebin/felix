#!/bin/bash

source ./common.sh

#####################
# Distribution name
#####################

##################
# Ubuntu version
##################
print_section_heading "Ubuntu Linux"
INSTALLER_MEDIA_INFO_PATH='/var/log/installer/media-info'
if [[ -f "${INSTALLER_MEDIA_INFO_PATH}" ]]; then
	printf "Ubuntu Linux detected:\n$(cat /var/log/installer/media-info)\n"
else
	echo "This is not Ubuntu"
fi
print_section_ending

########################
# Linux kernel version
########################

#######################
# Temperature sensors
#######################
print_section_heading "Temperature sensors"
sensors
print_section_ending

###################
# RAM information
###################
print_section_heading "/proc/meminfo"
cat /proc/meminfo
print_section_ending

print_section_heading "demidecode --type memory"
sudo dmidecode --type memory
print_section_ending

print_section_heading "Free memory"
free -m
print_section_ending

###############
# GTK version
###############
print_section_heading "GTK+ version"
dpkg -l libgtk2.0-0 libgtk-3-0
print_section_ending

# Java version

# Screens number and resolution
