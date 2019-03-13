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
	
	# Copy local settings
	cp "${HOME}/.config/mimeapps.list" "${SNAPSHOT_DIR}"
	
	# Query xdg-mime to retrieve the default application per mime type
	DEFAULT_APPLICATIONS_FILE="${SNAPSHOT_DIR}/xdg_mime_query_default.list"
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
		#printf "Querying default application for ${MIME_TYPE} ...\n"
		DEFAULT_APPLICATION=$(xdg-mime query default ${MIME_TYPE})
		(( QUERIED_MIME_TYPE_COUNT++ ))
		if [[ ! -z "${DEFAULT_APPLICATION}" ]]; then
			printf "%-30s%-30s\n" "${MIME_TYPE}" "${DEFAULT_APPLICATION}" >>"${DEFAULT_APPLICATIONS_FILE}"
		fi
	done < /etc/mime.types
	printf "%s mime types queries\n" "${QUERIED_MIME_TYPE_COUNT}"
	
	# Copy .desktop files for application autostart
	cp -r "${HOME}/.config/autostart" "${SNAPSHOT_DIR}"
	
	printf "\n"
}

# Retrieve previous snapshot
PREVIOUS_SNAPSHOT_DIR=$(find "${HOME}/.MimeTypeAndApplicationSnapshots" -maxdepth 1 -mindepth 1 -type d|grep -E '[0-9]{6}-[0-9]{6}'|sort|tail -n1)

# Create snapshot directory
SNAPSHOT_DIR="${HOME}/.MimeTypeAndApplicationSnapshots/$(date -u +'%y%m%d-%H%M%S')"
if [[ -d "${SNAPSHOT_DIR}" ]]; then
	printf "SNAPSHOT_DIR already exists: ${SNAPSHOT_DIR}"
	exit 1
fi
mkdir -p "${SNAPSHOT_DIR}"

# Snapshot MIME types & applications
create_snapshot_mime_types_and_applications "${SNAPSHOT_DIR}"

# Compare with PREVIOUS_SNAPSHOT_DIR if we have one
DELETE_SNAPSHOT_DIR=1
if [[ ! -z "${PREVIOUS_SNAPSHOT_DIR}" ]]; then
	printf "Comparing SNAPSHOT_DIR[%s] with PREVIOUS_SNAPSHOT_DIR[%s] ...\n" "${SNAPSHOT_DIR}" "${PREVIOUS_SNAPSHOT_DIR}"
	diff -r "${PREVIOUS_SNAPSHOT_DIR}" "${SNAPSHOT_DIR}"
	NO_DIFF=$?
	if (( ${NO_DIFF} )); then
		printf "Equality detected.\n"
	fi
	DELETE_SNAPSHOT_DIR=${NO_DIFF}
fi

#~ # Delete SNAPSHOT_DIR
#~ if (( ${KEEP_SNAPSHOT_DIR} )); then
	#~ rm -fr "${SNAPSHOT_DIR}"
#~ fi
