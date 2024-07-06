#!/usr/bin/env bash

key_value_retriever(){
	KEY="${1}"
	if [[ -z "${KEY}" ]]; then
		printf "ERROR: KEY should not be empty\n"
		return
	fi
	FILE="${2}"
	if [[ ! -f "${FILE}" ]]; then
		printf "ERROR: Cannot find FILE: %s\n" "${FILE}"
		return
	fi
	VALUE_VARNAME="${3}"
	if [[ -z "${VALUE_VARNAME}" ]]; then
		printf "ERROR: VALUE_VARNAME should not be empty\n"
		return
	fi
	MATCH=$(grep "^[[:space:]]*${KEY}=" "${FILE}")
	INDEX_OF_FIRST_EQUAL=$(expr index "${MATCH}" =)
	VALUE="${MATCH:${INDEX_OF_FIRST_EQUAL}}"
	VALUE="$(echo "${VALUE}" | sed "s/\r//g" )"
	export "${VALUE_VARNAME}"="${VALUE}"
}

CURRENT_WORKING_DIRECTORY="$(pwd)"
trap "cd '${CURRENT_WORKING_DIRECTORY}'" 0

cd "${HOME}/.local/share/remmina"

for REMMINA_FILE in *.remmina; do
	REMMINA_GROUP=""
	key_value_retriever "group" "${REMMINA_FILE}" "REMMINA_GROUP"
	REMMINA_GROUP_FORMATTED=$(echo "${REMMINA_GROUP}" | sed "s/[^[:alnum:]]/_/g" | tr -s "_" | sed "s/^_+//g" | sed "s/_+$//g")
	
	REMMINA_NAME=""
	key_value_retriever "name" "${REMMINA_FILE}" "REMMINA_NAME"
	REMMINA_NAME_FORMATTED=$(echo "${REMMINA_NAME}" | sed "s/[^[:alnum:]]/_/g" | tr -s "_" | sed "s/^_+//g" | sed "s/_+$//g")
	
	REMMINA_FILE_FORMATTED=$(printf "%s_#_%s.remmina" "${REMMINA_GROUP_FORMATTED}" "${REMMINA_NAME_FORMATTED}")
	if [[ "${REMMINA_FILE}" != "${REMMINA_FILE_FORMATTED}" ]]; then
		if [[ ! -f "${REMMINA_FILE_FORMATTED}" ]]; then
			mv "${REMMINA_FILE}" "${REMMINA_FILE_FORMATTED}"
		else
			printf "REMMINA_FILE_FORMATTED[%s] already exists for REMMINA_FILE[%s]\n" "${REMMINA_FILE_FORMATTED}" "${REMMINA_FILE}"
		fi
	fi
done
