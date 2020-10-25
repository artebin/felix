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
	export "${VALUE_VARNAME}"="${VALUE}"
}

REMMINA_FILES_PARENT_DIRECTORY="${HOME}/.local/share/remmina"

declare -A REMOTE_GROUP_ARRAY
declare -A REMMINA_FILE_ARRAY_PER_GROUP_ARRAY
declare -A REMOTE_NAME_ARRAY
declare -A REMOTE_PROTOCOL_ARRAY
declare -A REMOTE_REMMINA_FILE

for REMMINA_FILE in "${REMMINA_FILES_PARENT_DIRECTORY}"/*; do
	key_value_retriever "name" "${REMMINA_FILE}" "NAME"
	key_value_retriever "group" "${REMMINA_FILE}" "GROUP"
	key_value_retriever "protocol" "${REMMINA_FILE}" "PROTOCOL"
	REMOTE_GROUP_ARRAY["${GROUP}"]="${GROUP}"
	declare -a REMMINA_FILE_ARRAY_FOR_GROUP=${REMMINA_FILE_ARRAY_PER_GROUP_ARRAY[${GROUP}]}
	if [[ -z "${REMMINA_FILE_ARRAY_FOR_GROUP}" ]]; then
		REMMINA_FILE_ARRAY_PER_GROUP_ARRAY["${GROUP}"]="( ${REMMINA_FILE} )"
	else
		REMMINA_FILE_ARRAY_PER_GROUP_ARRAY["${GROUP}"]="( ${REMMINA_FILE_ARRAY_FOR_GROUP[@]} ${REMMINA_FILE} )"
	fi
	REMOTE_NAME_ARRAY["${REMMINA_FILE}"]="${NAME}"
	REMOTE_PROTOCOL_ARRAY["${REMMINA_FILE}"]="${PROTOCOL}"
	REMOTE_REMMINA_FILE["${REMMINA_FILE}"]="${REMMINA_FILE}"
done

generate_remmina_menu(){
	OPENBOX_MENU="<openbox_pipe_menu>"
	GROUP_NAME_ARRAY=( "${REMOTE_GROUP_ARRAY[@]}" )
	IFS=$'\n' GROUP_NAME_SORTED_ARRAY=($(sort <<<"${GROUP_NAME_ARRAY[*]}"))
	unset IFS
	for REMOTE_GROUP in "${GROUP_NAME_SORTED_ARRAY[@]}"; do
		OPENBOX_MENU+="<menu id=\"${REMOTE_GROUP}\" label=\"${REMOTE_GROUP}\">"
		declare -a REMMINA_FILE_ARRAY_FOR_GROUP_ARRAY=${REMMINA_FILE_ARRAY_PER_GROUP_ARRAY["${REMOTE_GROUP}"]}
		for REMMINA_FILE in "${REMMINA_FILE_ARRAY_FOR_GROUP_ARRAY[@]}"; do
			REMOTE_NAME="${REMOTE_NAME_ARRAY[${REMMINA_FILE}]}"
			REMOTE_PROCOTOL="${REMOTE_PROTOCOL_ARRAY[${REMMINA_FILE}]}"
			OPENBOX_MENU+="<item label=\"${REMOTE_NAME}\"><action name=\"Execute\"><command>remmina -c '${REMMINA_FILE}'</command></action></item>"
		done
		OPENBOX_MENU+="</menu>"
	done
	OPENBOX_MENU+="</openbox_pipe_menu>"
}

generate_remmina_menu_with_sub_menus_for_group_elements(){
	OPENBOX_MENU="<openbox_pipe_menu>"
	GROUP_NAME_ARRAY=( "${REMOTE_GROUP_ARRAY[@]}" )
	IFS=$'\n' GROUP_NAME_SORTED_ARRAY=($(sort <<<"${GROUP_NAME_ARRAY[*]}"))
	unset IFS
	for REMOTE_GROUP in "${GROUP_NAME_SORTED_ARRAY[@]}"; do
		IFS='/' read -r -a GROUP_ELEMENT_ARRAY <<< "${REMOTE_GROUP}"
		for GROUP_ELEMENT in "${GROUP_ELEMENT_ARRAY[@]}"; do
			OPENBOX_MENU+="<menu id=\"${GROUP_ELEMENT}\" label=\"${GROUP_ELEMENT}\">"
		done
		declare -a REMMINA_FILE_ARRAY_FOR_GROUP_ARRAY=${REMMINA_FILE_ARRAY_PER_GROUP_ARRAY["${REMOTE_GROUP}"]}
		for REMMINA_FILE in "${REMMINA_FILE_ARRAY_FOR_GROUP_ARRAY[@]}"; do
			REMOTE_NAME="${REMOTE_NAME_ARRAY[${REMMINA_FILE}]}"
			REMOTE_PROCOTOL="${REMOTE_PROTOCOL_ARRAY[${REMMINA_FILE}]}"
			OPENBOX_MENU+="<item label=\"${REMOTE_NAME}\"><action name=\"Execute\"><command>remmina -c '${REMMINA_FILE}'</command></action></item>"
		done
		for GROUP_ELEMENT in "${GROUP_ELEMENT_ARRAY[@]}"; do
			OPENBOX_MENU+="</menu>"
		done
	done
	OPENBOX_MENU+="</openbox_pipe_menu>"
}

OPENBOX_MENU="<openbox_pipe_menu/>"
generate_remmina_menu
#generate_remmina_menu_with_sub_menus_for_group_elements
printf "${OPENBOX_MENU}"
