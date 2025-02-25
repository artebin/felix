#!/usr/bin/env bash

function trace_fail(){
	if [[ $# -lt 1 ]]; then return; fi
	FAIL_MESSAGE="${1}"
	printf "[ERROR] ${1}\n" "${@:2}" 2>&1
}
function trace_info(){
	if [[ $# -lt 1 ]]; then return; fi
	INFO_MESSAGE="${1}"
	printf "[INFO ] ${1}\n" "${@:2}"
}
function trace_debug(){
	if [[ $# -lt 1 ]]; then return; fi
	DEBUG_MESSAGE="${1}"
	printf "[DEBUG] ${1}\n" "${@:2}"
}

function print_usage(){
	printf "Usage: $(basename ${BASH_SOURCE}) [-a ADDRESS] [-p PORT_NUMBER]\n"
}

ADDRESS=""
PORT_NUMBER="13111"

while getopts ":a:p:" ARG; do
	case "${ARG}" in
		a)
			ADDRESS="${OPTARG}"
			;;
		p)
			PORT_NUMBER="${OPTARG}"
			;;
		*)
			trace_fail "Unknown option: -%s" "${OPTARG}"
			print_usage
			exit 1
			;;
	esac
done

# Show menu for ADDRESS if not given in parameters
if [[ -z "${ADDRESS}" ]]; then
	declare -A ALL_ADDRESSES_ARRAY
	ALL_ADDRESSES="$(ip -4 -br addr 2>/dev/null)"
	if [[ "${?}" != 0 ]]; then trace_fail "Cannot retrieve list of network interfaces and IP addresses"; exit 1; fi
	REGEX_IP_BR_ADDR="([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+).*"
	printf "Select server address:\n"
	while IFS= read -r LINE; do
		if [[ "${LINE}" =~ ${REGEX_IP_BR_ADDR} ]]; then
			INTF_NAME="${BASH_REMATCH[1]}"
			INTF_STATUS="${BASH_REMATCH[2]}"
			ADDRESS="${BASH_REMATCH[3]}"
			printf -v ADDRESS_CHOICE "%-15s [%s / %s]" "${ADDRESS}" "${INTF_NAME}" "${INTF_STATUS}"
			ALL_ADDRESSES_ARRAY["${ADDRESS_CHOICE}"]="${ADDRESS}"
		fi
	done <<< "${ALL_ADDRESSES}"
	select SELECTED_ADDRESS in "${!ALL_ADDRESSES_ARRAY[@]}" exit; do
		if [[ "${SELECTED_ADDRESS}" == "exit" ]]; then
			exit 0
		fi
		if [[ -z "${SELECTED_ADDRESS}" ]]; then
			printf "Please enter a number!\n"
			continue
		fi
		break;
	done
	ADDRESS="${ALL_ADDRESSES_ARRAY[${SELECTED_ADDRESS}]}"
fi

# Check host with ADDRESS is reachable
HOST_AVAILABLE="$(ping -c 1 "${ADDRESS}" >/dev/null 2>&1;echo "${?}")"
if [[ "${HOST_AVAILABLE}" -ne 0 ]]; then
	trace_fail "Host at ADDRESS[%s] is unreachable" "${ADDRESS}"
	exit 1
fi

# Check PORT_NUMBER
if [[ ! "${PORT_NUMBER}" =~ ^[0-9]+$ ]]; then
	trace_fail "PORT_NUMBER[%s] is not a valid port number" "${PORT_NUMBER}"
	exit 1
fi

# Create local and remote apt_sources.list files for all mirrors found in the working directory
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
python3 -m http.server -b "${ADDRESS}" "${PORT_NUMBER}"
