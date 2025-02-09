#!/usr/bin/env bash

if [[ "${#}" != 2 ]]; then
	printf "!ERROR! Source and target image files are expected in arguments\n"
	exit 1
fi

SOURCE_IMAGE_FILE=$( basename "${1}" )
TARGET_IMAGE_FILE=$( basename "${2}" )

if [[ ! -f "${SOURCE_IMAGE_FILE}" ]]; then
	printf "!ERROR! cannot find SOURCE_IMAGE_FILE[%s]\n" "${SOURCE_IMAGE_FILE}"
	exit 1
fi

convert -flop "${SOURCE_IMAGE_FILE}" "${TARGET_IMAGE_FILE}"
convert -resize 280x "${TARGET_IMAGE_FILE}" "${TARGET_IMAGE_FILE%.*}_thumb.${TARGET_IMAGE_FILE##*.}"
