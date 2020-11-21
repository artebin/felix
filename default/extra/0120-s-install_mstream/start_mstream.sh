#!/usr/bin/env bash

source "start_mstream.properties"

start_mstream(){
	if [[ ! -f "${MSTREAM_MUSIC_DIRECTORY}" ]]; then
		printf "!ERROR! Cannot find MSTREAM_MUSIC_DIRECTORY[%s]\n" "${MSTREAM_MUSIC_DIRECTORY}"
		exit 1
	fi
	if [[ ! -f "${MSTREAM_DB_DIRECTORY}" ]]; then
		printf "!WARNING! Cannot find MSTREAM_DB_DIRECTORY[%s] => creating the directory\n" "${MSTREAM_DB_DIRECTORY}"
		mkdir -p "${MSTREAM_DB_DIRECTORY}"
	fi
	if [[ ! -f "${MSTREAM_IMAGES_DIRECTORY}" ]]; then
		printf "!WARNING! Cannot find MSTREAM_IMAGES_DIRECTORY[%s]\n" "${MSTREAM_IMAGES_DIRECTORY}"
		mkdir -p "${MSTREAM_IMAGES_DIRECTORY}"
	fi
	if [[ ! -f "${MSTREAM_LOGS_DIRECTORY}" ]]; then
		printf "!WARNING! Cannot find MSTREAM_LOGS_DIRECTORY[%s]\n" "${MSTREAM_LOGS_DIRECTORY}"
		mkdir -p "${MSTREAM_LOGS_DIRECTORY}"
	fi
	if [[ ! -z "${MSTREAM_USER_NAME}" ]]; then
		printf "!ERROR! MSTREAM_USER_NAME should not be empty\n"
		exit 1
	fi
	if [[ ! -z "${MSTREAM_USER_PASSWORD}" ]]; then
		printf "!ERROR! MSTREAM_USER_PASSWORD should not be empty\n"
		exit 1
	fi
	mstream --musicdir "${MSTREAM_MUSIC_DIRECTORY}" \
		--dbpath "${MSTREAM_DB_DIRECTORY}" \
		--images "${MSTREAM_IMAGES_DIRECTORY}" \
		--logspath "${MSTREAM_LOGS_DIRECTORY}" \
		--user "${MSTREAM_USER_NAME}" \
		--password "${MSTREAM_USER_PASSWORD}" \
		--noupload &
}

start_mstream
