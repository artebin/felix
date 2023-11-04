#!/usr/bin/env bash

print_usage(){
	printf "Usage: ${0} [-a <ADDRESS>] [-p <PORT_NUMBER>]\n"
}

DEFAULT_ADDRESS="localhost"
ADDRESS="${DEFAULT_ADDRESS}"

DEFAULT_PORT_NUMBER=10001
PORT_NUMBER="${DEFAULT_PORT_NUMBER}"

while getopts ":p:a:m:" ARG; do
	case "${ARG}" in
		a)
			ADDRESS="${OPTARG}"
			;;
		p)
			PORT_NUMBER="${OPTARG}"
			;;
		\?)
			printf "${0}: invalid option\n" 1>&2
			print_usage
			exit 1
			;;
	esac
done

# Check host with IP_ADDRESS is reachable
ping -c 1 "${ADDRESS}" >/dev/null 2>&1
HOST_AVAILABLE="$?"
if [[ "${HOST_AVAILABLE}" -ne 0 ]]; then
	printf "${0}: host at ADDRESS[%s] is not available\n" "${ADDRESS}" 1>&2
	exit 1
fi

# Check PORT_NUMBER
if [[ ! "${PORT_NUMBER}" =~ ^-?[0-9]+$ ]]; then
	printf "${0}: PORT_NUMBER[%s] is not a valid port number\n" "${PORT_NUMBER}" 1>&2
	exit 1
fi

# Create local and remote apt_sources.list files for all mirrors found in the directory
readarray -t MIRROR_LIST_FILE_ARRAY < <(find ./ -maxdepth 2 -type f -name "*.mirror.list" -exec readlink -f {} \;|sort)
for MIRROR_LIST_FILE in "${MIRROR_LIST_FILE_ARRAY[@]}"; do
	MIRROR_NAME=$(dirname "${MIRROR_LIST_FILE}" | xargs basename)
	
	LOCAL_APT_SOURCES_FILE="${MIRROR_NAME}.local.apt_sources.list"
	cat "${MIRROR_LIST_FILE}" | sed -n '/^# SOURCES START #/,/^# SOURCES END #/p;/^#SOURCES END#/q' > "${LOCAL_APT_SOURCES_FILE}"
	sed -i "s|deb |deb [arch=amd64] |g" "${LOCAL_APT_SOURCES_FILE}"
	sed -i "s|http://|http://${ADDRESS}:${PORT_NUMBER}/${MIRROR_NAME}/mirror/|g" "${LOCAL_APT_SOURCES_FILE}"
	
	REMOTE_APT_SOURCES_FILE="${MIRROR_NAME}.remote.apt_sources.list"
	cat "${MIRROR_LIST_FILE}" | sed -n '/^# SOURCES START #/,/^# SOURCES END #/p;/^#SOURCES END#/q' > "${REMOTE_APT_SOURCES_FILE}"
	sed -i "s|deb |deb [arch=amd64] |g" "${REMOTE_APT_SOURCES_FILE}"
done

# Start the HTTP server
python3 -m http.server "${PORT_NUMBER}"
