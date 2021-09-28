#!/usr/bin/env bash

print_usage(){
	printf "Usage: ${0} [-r]\n"
	printf "Options:\n"
	printf "  -r          respawned the server if it crashed\n"
	printf "\n"
}

start_vnc_server(){
	x0tigervncserver -display :0 -passwordfile ${HOME}/.vnc/passwd
}

RESPAWN="false"
while getopts ":r" OPT; do
	case "${OPT}" in
		r)
			RESPAWN="true"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

if [[ $# != 0 ]]; then
	print_usage
	exit 1
fi

# Make sure the server is not already running
killall -s 9 x0tigervncserver;

if ! ${RESPAWN}; then
	start_vnc_server
else
	until start_vnc_server; do
		printf "VNC server crashed with exit code $?.\nRespawning ...\n"
		sleep 1
	done
fi
