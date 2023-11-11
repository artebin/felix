#!/usr/bin/env bash

SCRIPT_NAME="$(basename "${BASH_SOURCE}")"

print_usage(){
	cat << EOF
Usage: ${0} [-r]

Options:
  -r        Respawn the server if it crashed.
EOF
}

start_vnc_server(){
	VNC_SERVER_COMMAND="x0tigervncserver"
	if type "x0tigervncserver" >/dev/null 2>&1; then
		VNC_SERVER_COMMAND="x0tigervncserver"
	elif type "x0vncserver" >/dev/null 2>&1; then
		VNC_SERVER_COMMAND="x0vncserver"
	fi
	${VNC_SERVER_COMMAND} -display :0 -passwordfile ${HOME}/.vnc/passwd -localhost no &
	SERVER_PID=$!
	printf "${SERVER_PID}" > "${PID_LIST_FILE}"
	wait "${SERVER_PID}"
}

PID_LIST_FILE="/run/user/${UID}/$(basename $0).pid_list"

kill_registered_processes(){
	PID_LIST=$(cat "${PID_LIST_FILE}")
	printf "${SCRIPT_NAME}: kill_registered_processes PID_LIST[%s]\n" "${PID_LIST}"
	kill -s 9 ${PID_LIST} 2>&1 2>/dev/null
}

trap kill_registered_processes 0

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

# Check if VNC is properly configured: the passwd file is mandatory
if [[ ! -f "~/.vnc/passwd" ]]; then
	printf "${SCRIPT_NAME}: Cannot start VNC server because passwd file is missing. Please execute the \'vncpass\' command.\n" 1>&2
	exit 1
fi

# Make sure the server is not already running
kill_registered_processes

if ! ${RESPAWN}; then
	start_vnc_server
else
	until start_vnc_server; do
		printf "${SCRIPT_NAME}: VNC server crashed with exit code $?.\nRespawning ...\n"
		sleep 1
	done
fi
