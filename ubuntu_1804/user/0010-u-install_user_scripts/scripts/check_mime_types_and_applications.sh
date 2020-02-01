#!/usr/bin/env bash

create_snapshot_mime_types_and_applications(){
	if [[ $# -ne 1 ]]; then
		printf "Function create_snapshot_mime_types_and_applications() expects SNAPSHOT_DIR in parameter\n"
		exit 1
	fi
	SNAPSHOT_DIR="${1}"
	if [[ ! -d "${SNAPSHOT_DIR}" ]]; then
		printf "Cannot find SNAPSHOT_DIR: ${SNAPSHOT_DIR}\n"
		exit 1
	fi
	
	printf "Creating a snapshot of the MIME types and applications ...\n"
	printf "SNAPSHOT_DIR: ${SNAPSHOT_DIR}\n"
	
	# See <https://unix.stackexchange.com/questions/114075/how-to-get-a-list-of-applications-associated-with-a-file-using-command-line>
	
	# Copy global settings
	cp /usr/share/applications/mimeinfo.cache "${SNAPSHOT_DIR}"
	sed -e 's/=/\n\t/' -e 's/;/\n\t/g' /usr/share/applications/mimeinfo.cache >"${SNAPSHOT_DIR}/mimeinfo.cache.info"
	
	# Copy local settings
	cp "${HOME}/.config/mimeapps.list" "${SNAPSHOT_DIR}"
	sed -e 's/=/\n\t/' -e 's/;/\n\t/g' "${HOME}/.config/mimeapps.list" >"${SNAPSHOT_DIR}/mimeapps.list.info"
	
	# Copy .desktop files for application autostart
	cp -r "${HOME}/.config/autostart" "${SNAPSHOT_DIR}"
	
	printf "\n"
}

query_xdg_mime_defaults(){
	if [[ $# -ne 1 ]]; then
		printf "Function xdg_mime_query_defaults() expects SNAPSHOT_DIR in parameter\n"
		exit 1
	fi
	SNAPSHOT_DIR="${1}"
	if [[ ! -d "${SNAPSHOT_DIR}" ]]; then
		printf "Cannot find SNAPSHOT_DIR: ${SNAPSHOT_DIR}\n"
		exit 1
	fi
	
	printf "Querying xdg-mime defaults per mime type in /etc/mime.types ...\n"
	
	OUTPUT_FILE="${SNAPSHOT_DIR}/xdg_mime_query_defaults.list"
	QUERIED_MIME_TYPE_COUNT=0
	while read LINE; do
		MIME_TYPE=""
		if [[ "${LINE}" =~ ^#.* ]]; then
			continue
		fi
		if [[ "${LINE}" =~ .*[0-9a-zA-Z].* ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
		fi
		if [[ -z "${MIME_TYPE}" ]]; then
			continue
		fi
		DEFAULT_APPLICATION=$(xdg-mime query default ${MIME_TYPE})
		(( QUERIED_MIME_TYPE_COUNT++ ))
		if [[ ! -z "${DEFAULT_APPLICATION}" ]]; then
			printf "%-30s%-30s\n" "${MIME_TYPE}" "${DEFAULT_APPLICATION}" >>"${OUTPUT_FILE}"
		fi
	done < /etc/mime.types
	printf "%s mime types queries\n" "${QUERIED_MIME_TYPE_COUNT}"
	
	printf "\n"
}

compare_snapshots_and_delete_if_no_changes(){
	if [[ $# -ne 2 ]]; then
		printf "Function compare_snapshots_and_delete_if_no_changes() expects LEFT_SNAPSHOT_DIR and RIGHT_SNAPSHOT_DIR in parameter\n"
		exit 1
	fi
	LEFT_SNAPSHOT_DIR="${1}"
	if [[ ! -d "${LEFT_SNAPSHOT_DIR}" ]]; then
		printf "Cannot find LEFT_SNAPSHOT_DIR: ${LEFT_SNAPSHOT_DIR}\n"
		exit 1
	fi
	RIGHT_SNAPSHOT_DIR="${2}"
	if [[ ! -d "${RIGHT_SNAPSHOT_DIR}" ]]; then
		printf "Cannot find RIGHT_SNAPSHOT_DIR: ${RIGHT_SNAPSHOT_DIR}\n"
		exit 1
	fi
	
	printf "Comparing LEFT_SNAPSHOT_DIR[%s] with RIGHT_SNAPSHOT_DIR[%s] ...\n" "$(basename "${LEFT_SNAPSHOT_DIR}")" "$(basename "${RIGHT_SNAPSHOT_DIR}")"
	DELETE_RIGHT_SNAPSHOT_DIR=1
	diff -r "${LEFT_SNAPSHOT_DIR}" "${RIGHT_SNAPSHOT_DIR}" 2>&1 >/dev/null
	DIFFERENCE_DETECTED=$?
	if (( ${DIFFERENCE_DETECTED} )); then
		printf "The 2 snapshots differ.\n"
		DELETE_RIGHT_SNAPSHOT_DIR=0
	else
		printf "No difference detected, RIGHT_SNAPSHOT_DIR will be deleted ...\n"
	fi
	
	if (( ${DELETE_RIGHT_SNAPSHOT_DIR} )); then
		rm -fr "${SNAPSHOT_DIR}"
	fi
	
	printf "\n"
}

SNAPSHOTS_DIR="${HOME}/.MimeTypeAndApplicationSnapshots"

if [[ ! -d "${SNAPSHOTS_DIR}" ]]; then
	printf "SNAPSHOTS_DIR does not exists\n"
	printf "Create SNAPSHOTS_DIR: %s\n" "${SNAPSHOTS_DIR}"
fi

# Retrieve previous snapshot
PREVIOUS_SNAPSHOT_DIR=$(find "${SNAPSHOTS_DIR}" -maxdepth 1 -mindepth 1 -type d|grep -E '[0-9]{6}-[0-9]{6}'|sort|tail -n1)

# Create snapshot directory for current run
SNAPSHOT_DIR="${SNAPSHOTS_DIR}/$(date -u +'%y%m%d-%H%M%S')"
if [[ -d "${SNAPSHOT_DIR}" ]]; then
	printf "SNAPSHOT_DIR already exists: ${SNAPSHOT_DIR}"
	exit 1
fi
mkdir -p "${SNAPSHOT_DIR}"

# Create a snapshot of MIME types & applications
create_snapshot_mime_types_and_applications "${SNAPSHOT_DIR}"

# Compare SNAPSHOT_DIR with PREVIOUS_SNAPSHOT_DIR and delete PREVIOUS_SNAPSHOT_DIR if no difference detected
if [[ ! -z "${PREVIOUS_SNAPSHOT_DIR}" ]]; then
	compare_snapshots_and_delete_if_no_changes "${PREVIOUS_SNAPSHOT_DIR}" "${SNAPSHOT_DIR}"
fi
