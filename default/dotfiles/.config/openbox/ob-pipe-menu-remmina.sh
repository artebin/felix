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

trim(){
	TEXT="${1}"
	if [[ -z "${TEXT}" ]]; then
		printf "ERROR: TEXT should not be empty\n"
		return
	fi
	VALUE_VARNAME="${2}"
	if [[ -z "${VALUE_VARNAME}" ]]; then
		printf "ERROR: VALUE_VARNAME should not be empty\n"
		return
	fi
	# Remove leading whitespace characters
	TEXT="${TEXT#"${TEXT%%[![:space:]]*}"}"
	# Remove trailing whitespace characters
	TEXT="${TEXT%"${TEXT##*[![:space:]]}"}"
	export "${VALUE_VARNAME}"="${TEXT}"
}

rename_remmina_files(){
	for REMMINA_FILE in "${REMMINA_FILES_PARENT_DIRECTORY}"/*; do
		key_value_retriever "group" "${REMMINA_FILE}" "REMOTE_GROUP"
		key_value_retriever "name" "${REMMINA_FILE}" "REMOTE_NAME"
		key_value_retriever "protocol" "${REMMINA_FILE}" "REMOTE_PROTOCOL"
		
		TARGET_FILE_BASE_NAME="${REMOTE_GROUP}-${REMOTE_NAME}-${REMOTE_PROTOCOL}"
		TARGET_FILE_BASE_NAME=$( echo "${TARGET_FILE_BASE_NAME}" | sed "s/[^[:alnum:]_-]/-/g" | sed "s/--*/-/g" )
		
		TARGET_FILE="${REMMINA_FILES_PARENT_DIRECTORY}/${TARGET_FILE_BASE_NAME}.remmina"
		if [[ -f "${TARGET_FILE}" ]]; then
			TARGET_FILE_COUNT=$( ls -1 "${REMMINA_FILES_PARENT_DIRECTORY}/${TARGET_FILE_BASE_NAME}"* | wc -l )
			TARGET_FILE="${REMMINA_FILES_PARENT_DIRECTORY}/${TARGET_FILE_BASE_NAME}.${TARGET_FILE_COUNT}.remmina"
		fi
		mv "${REMMINA_FILE}" "${TARGET_FILE}"
	done
}

REMMINA_FILES_PARENT_DIRECTORY="${HOME}/.local/share/remmina"
declare -A REMOTE_GROUP_ARRAY
declare -A REMOTE_NAME_ARRAY
declare -A REMOTE_PROTOCOL_ARRAY

declare -A MENU_TREE_ARRAY
declare -A MENU_NODE_KEY_ARRAY
declare -A MENU_NODE_REMMINA_FILE_ARRAY
declare -A MENU_NODE_DISPLAY_NAME_ARRAY

MENU_ROOT_NODE_KEY="ROOT"
MENU_TREE_SIZE="0"
MENU_NODE_DISPLAY_NAME_ARRAY["${MENU_ROOT_NODE_KEY}"]="ROOT"

build_menu_tree_array(){
	for REMMINA_FILE in "${REMMINA_FILES_PARENT_DIRECTORY}"/*; do
		key_value_retriever "group" "${REMMINA_FILE}" "REMOTE_GROUP"
		key_value_retriever "name" "${REMMINA_FILE}" "REMOTE_NAME"
		key_value_retriever "protocol" "${REMMINA_FILE}" "REMOTE_PROTOCOL"
		
		REMOTE_GROUP_ARRAY["${REMMINA_FILE}"]="${REMOTE_GROUP}"
		REMOTE_NAME_ARRAY["${REMMINA_FILE}"]="${REMOTE_NAME}"
		REMOTE_PROTOCOL_ARRAY["${REMMINA_FILE}"]="${REMOTE_PROTOCOL}"
		
		MENU_ELEMENT_ARRAY=()
		
		# Retrieve GROUP_ELEMENT_ARRAY
		IFS='/' read -r -a GROUP_ELEMENT_ARRAY <<< "${REMOTE_GROUP}"
		
		# Trim the group elements and fill MENU_ELEMENT_ARRAY
		for GROUP_ELEMENT in "${GROUP_ELEMENT_ARRAY[@]}"; do
			trim "${GROUP_ELEMENT}" "TRIMMED_GROUP_ELEMENT"
			MENU_ELEMENT_ARRAY+=( "${TRIMMED_GROUP_ELEMENT}" )
		done
		
		# Add the reminna file as a leaf in the menu elements
		MENU_ELEMENT_ARRAY+=( "${REMMINA_FILE}" )
		
		# Fill MENU_TREE_ARRAY
		CURRENT_MENU_NODE_KEY="${MENU_ROOT_NODE_KEY}"
		while [[ "${#MENU_ELEMENT_ARRAY[@]}" -ne 0 ]]; do
			# Pop CURRENT_MENU_ELEMENT
			CURRENT_MENU_CHILD_ELEMENT="${MENU_ELEMENT_ARRAY[0]}"
			MENU_ELEMENT_ARRAY=( "${MENU_ELEMENT_ARRAY[@]:1}" )
			
			# Retrieve known children for CURRENT_MENU_NODE_KEY
			declare -a CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY="( ${MENU_TREE_ARRAY[${CURRENT_MENU_NODE_KEY}]} )"
			
			# Retrieve node for CURRENT_MENU_CHILD_ELEMENT 
			CURRENT_MENU_CHILD_ELEMENT_HASH="${CURRENT_MENU_NODE_KEY} # ${CURRENT_MENU_CHILD_ELEMENT}"
			CURRENT_MENU_CHILD_NODE_KEY="${MENU_NODE_KEY_ARRAY[${CURRENT_MENU_CHILD_ELEMENT_HASH}]}"
			
			# Create a new node if cannot retrieve CURRENT_MENU_CHILD_NODE_KEY
			if [[ -z "${CURRENT_MENU_CHILD_NODE_KEY}" ]]; then
				((++MENU_TREE_SIZE))
				CURRENT_MENU_CHILD_NODE_KEY="NODE_${MENU_TREE_SIZE}"
				
				MENU_NODE_KEY_ARRAY["${CURRENT_MENU_CHILD_ELEMENT_HASH}"]="${CURRENT_MENU_CHILD_NODE_KEY}"
				
				if [[ "${#MENU_ELEMENT_ARRAY[@]}" -eq 0 ]]; then
					MENU_NODE_DISPLAY_NAME_ARRAY["${CURRENT_MENU_CHILD_NODE_KEY}"]="${REMOTE_NAME_ARRAY[${CURRENT_MENU_CHILD_ELEMENT}]}"
					MENU_NODE_REMMINA_FILE_ARRAY["${CURRENT_MENU_CHILD_NODE_KEY}"]="${CURRENT_MENU_CHILD_ELEMENT}"
				else
					MENU_NODE_DISPLAY_NAME_ARRAY["${CURRENT_MENU_CHILD_NODE_KEY}"]="${CURRENT_MENU_CHILD_ELEMENT}"
				fi
				
				# Register the new node as a child of CURRENT_MENU_NODE_KEY
				CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY+=( "${CURRENT_MENU_CHILD_NODE_KEY}" )
				MENU_TREE_ARRAY["${CURRENT_MENU_NODE_KEY}"]="${CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY[@]}"
			fi
			
			CURRENT_MENU_NODE_KEY="${CURRENT_MENU_CHILD_NODE_KEY}"
		done
	done
}

debug_menu_tree_array_rec(){
	local CURRENT_MENU_NODE_DEPTH="${1}"
	if [[ -z "${CURRENT_MENU_NODE_DEPTH}" ]]; then
		printf "ERROR: CURRENT_MENU_NODE_DEPTH should not be empty\n"
		return
	fi
	
	local CURRENT_MENU_NODE_KEY="${2}"
	if [[ -z "${CURRENT_MENU_NODE_KEY}" ]]; then
		printf "ERROR: CURRENT_MENU_NODE_KEY should not be empty\n"
		return
	fi
	
	local CURRENT_MENU_NODE_DISPLAY_NAME="${MENU_NODE_DISPLAY_NAME_ARRAY[${CURRENT_MENU_NODE_KEY}]}"
	
	if [[ "${CURRENT_MENU_NODE_DEPTH}" -ne 0 ]]; then
		printf '%0.s    ' $( seq 1 ${CURRENT_MENU_NODE_DEPTH} )
	fi
	printf "%s [%s][%s]\n" "${CURRENT_MENU_NODE_DISPLAY_NAME}" "${CURRENT_MENU_NODE_KEY}" "${CURRENT_MENU_NODE_DEPTH}"
	
	# Retrieve known children for CURRENT_MENU_NODE_KEY
	declare -a CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY="( ${MENU_TREE_ARRAY[${CURRENT_MENU_NODE_KEY}]} )"
	for CURRENT_MENU_CHILD_NODE_KEY in "${CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY[@]}"; do
		debug_menu_tree_array_rec "$(( ${CURRENT_MENU_NODE_DEPTH} + 1 ))" "${CURRENT_MENU_CHILD_NODE_KEY}"
	done
}

debug_menu_tree_array(){
	debug_menu_tree_array_rec "0" "${MENU_ROOT_NODE_KEY}"
}

print_openbox_pipe_menu_rec(){
	local CURRENT_MENU_NODE_DEPTH="${1}"
	if [[ -z "${CURRENT_MENU_NODE_DEPTH}" ]]; then
		printf "ERROR: CURRENT_MENU_NODE_DEPTH should not be empty\n"
		return
	fi
	
	local CURRENT_MENU_NODE_KEY="${2}"
	if [[ -z "${CURRENT_MENU_NODE_KEY}" ]]; then
		printf "ERROR: CURRENT_MENU_NODE_KEY should not be empty\n"
		return
	fi
	
	local CURRENT_MENU_NODE_DISPLAY_NAME="${MENU_NODE_DISPLAY_NAME_ARRAY[${CURRENT_MENU_NODE_KEY}]}"
	
	# Retrieve known children for CURRENT_MENU_NODE_KEY
	declare -a CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY="( ${MENU_TREE_ARRAY[${CURRENT_MENU_NODE_KEY}]} )"
	
	if [[ "${CURRENT_MENU_NODE_DEPTH}" -eq 0 ]]; then
		for CURRENT_MENU_CHILD_NODE_KEY in "${CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY[@]}"; do
			print_openbox_pipe_menu_rec "$((++CURRENT_MENU_NODE_DEPTH))" "${CURRENT_MENU_CHILD_NODE_KEY}"
		done
	else
		if [[ "${#CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY[@]}" -eq 0 ]]; then
			local REMMINA_FILE="${MENU_NODE_REMMINA_FILE_ARRAY[${CURRENT_MENU_NODE_KEY}]}"
			OPENBOX_MENU+="<item label=\"${CURRENT_MENU_NODE_DISPLAY_NAME}\"><action name=\"Execute\"><command>remmina -c \'${REMMINA_FILE}\'</command></action></item>\n"
		else
			OPENBOX_MENU+="<menu id=\"${CURRENT_MENU_NODE_KEY}\" label=\"${CURRENT_MENU_NODE_DISPLAY_NAME}\">\n"
			for CURRENT_MENU_CHILD_NODE_KEY in "${CHILDREN_FOR_CURRENT_MENU_NODE_KEY_ARRAY[@]}"; do
				print_openbox_pipe_menu_rec "$((++CURRENT_MENU_NODE_DEPTH))" "${CURRENT_MENU_CHILD_NODE_KEY}"
			done
			OPENBOX_MENU+="</menu>\n"
		fi
	fi
}

print_openbox_pipe_menu(){
	OPENBOX_MENU="<openbox_pipe_menu>\n"
	print_openbox_pipe_menu_rec "0" "${MENU_ROOT_NODE_KEY}"
	OPENBOX_MENU+="</openbox_pipe_menu>\n"
	printf "${OPENBOX_MENU}"
}

if [[ -d "${REMMINA_FILES_PARENT_DIRECTORY}" ]]; then
build_menu_tree_array
#debug_menu_tree_array
print_openbox_pipe_menu
#rename_remmina_files
fi
