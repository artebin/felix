#!/usr/bin/env bash

function print_dmi_product_information(){
	sudo -v
	for FILE in /sys/class/dmi/id/product_*; do
		printf "${FILE}:\n"
		FILE_CONTENT=$(sudo cat "${FILE}"|sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g')
		if [[ ! -z "${FILE_CONTENT}" ]]; then
			printf "${FILE_CONTENT}\n" | sed "s/^/  /g"
		else
			printf "  !! empty file\n"
		fi
	done
	printf "\n"
}
alias print_dmi_product_information=print_dmi_product_information

function print_distro_codename(){
	lsb_release --codename --short
}
alias print_distro_codename=print_distro_codename

function print_screen_dimension(){
	SCREEN_DIMENSION=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')
	printf "${SCREEN_DIMENSION}"
}
alias print_screen_dimension=print_screen_dimension

function print_connected_monitors(){
	xrandr | grep ' connected'
}
alias print_connected_monitors=print_connected_monitors

function print_geometry_of_primary_monitor(){
	xrandr | grep ' connected primary' | cut -d" " -f4
}
alias print_geometry_of_primary_monitor=print_geometry_of_primary_monitor

function ls_socket_for_pid(){
	PID="${1}"
	if [[ -z "${PID}" ]]; then
		printf "Usage: %s PID\n" "${FUNCNAME[0]}"
		return
	fi
	lsof -Pan -p ${PID} -i
}
alias ls_socket_for_pid=ls_socket_for_pid

function desc_for_pid(){
	if [[ $# -eq 0 ]]; then
		printf "Usage: %s PID_LIST\n" "${FUNCNAME[0]}"
		return
	fi
	PS_ARGS=""
	for PID in $@; do
		PS_ARGS+="-p ${PID} "
	done
	echo "${PS_ARGS}"
	ps ${PS_ARGS} -o pid,vsz=MEMORY -o user,group=GROUP -o comm,args=ARGS
}
alias desc_for_pid=desc_for_pid
