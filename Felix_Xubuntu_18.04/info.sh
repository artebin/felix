#!/usr/bin/env bash

source ./Felix_Xubuntu_18.04.sh
check_shell
exit_if_has_not_root_privileges

################
# Product name
################
print_section_heading "Product name"
sudo dmidecode -s system-product-name
print_section_ending

#################
# Hardware info
#################
print_section_heading "Hardware information (inxi -Fxz)"
inxi -Fxz
print_section_ending

###################
# RAM information
###################
print_section_heading "RAM information (demidecode --type memory)"
sudo dmidecode --type memory
print_section_ending

############
# Displays
############
print_section_heading "Displays"
xrandr --current
print_section_ending

#####################
# Distribution name
#####################
print_section_heading "Distribution name"
lsb_release -a
print_section_ending

##################
# Ubuntu version
##################
print_section_heading "Ubuntu Version (cat /var/log/installer/media-info)"
cat /var/log/installer/media-info
print_section_ending

########################
# Linux kernel version
########################
print_section_heading "Linux Kernel Version"
print_section_ending

###############
# Memory info
###############
print_section_heading "Memory info (cat /proc/meminfo)"
cat /proc/meminfo
print_section_ending

#########################
# Free memory (free -m)
#########################
print_section_heading "Free memory (free -m)"
free -m
print_section_ending

#######################
# Temperature sensors
#######################
print_section_heading "Temperature sensors"
sensors
print_section_ending

#####################
# Swaps information
#####################
print_section_heading "/proc/swaps"
cat /proc/swaps
print_section_ending

###############
# GTK version
###############
print_section_heading "GTK+ version"
dpkg -l libgtk2.0-0 libgtk-3-0
print_section_ending
