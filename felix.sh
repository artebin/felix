#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE})/common.sh"

FELIX_BANNER='  __      _ _      
 / _| ___| (_)_  __
| |_ / _ \ | \ \/ /
|  _|  __/ | |>  < 
|_|  \___|_|_/_/\_\'

retrieve_log_file_name(){
	if [[ $# -ne 1 ]]; then
		printf "retrieve_log_file_name() expects FILE_NAME in argument\n"
		exit 1
	fi
	FILE_NAME="${1}"
	LOG_FILE_NAME="${FILE_NAME}.log.$(date -u +'%y%m%d-%H%M%S')"
	echo "${LOG_FILE_NAME}"
}

list_log_files(){
	find . -iname "*.log.*" -type f
}

delete_log_files(){
	find . -name "*.log.*" -type f -exec rm -fr {} \;
}

retrieve_recipe_family_dir(){
	if [[ $# -ne 1 ]]; then
		printf "retrieve_recipe_family_dir() expects RECIPE_DIR in argument\n"
		exit 1
	fi
	FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_DIR##*/felix/}"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_FAMILY_DIR_NAME%%/*}"
	RECIPE_FAMILY_DIR="${FELIX_ROOT}/${RECIPE_FAMILY_DIR_NAME}"
	printf "${RECIPE_FAMILY_DIR}"
}

retrieve_recipe_family_conf_file(){
	if [[ $# -ne 1 ]]; then
		printf "retrieve_recipe_family_conf_file() expects RECIPE_DIR in argument\n"
		exit 1
	fi
	FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_DIR##*/felix/}"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_FAMILY_DIR_NAME%%/*}"
	RECIPE_FAMILY_DIR="${FELIX_ROOT}/${RECIPE_FAMILY_DIR_NAME}"
	printf "${RECIPE_FAMILY_DIR}/${RECIPE_FAMILY_DIR_NAME}.conf"
}

RECIPE_NAME_REGEX="([0-9][0-9][0-9][0-9])-([us])-(.*)"

fill_array_with_recipe_directory_from_recipe_family_directory(){
	if [[ $# -ne 2 ]]; then
		printf "fill_array_with_recipe_directory_from_recipe_family_directory() expects RECIPE_FAMILY_DIR and ARRAY_NAME in argument\n"
		exit 1
	fi
	local RECIPE_FAMILY_DIR="${1}"
	if [[ ! -d "${RECIPE_FAMILY_DIR}" ]]; then
		printf "Cannot find RECIPE_FAMILY_DIR: ${RECIPE_FAMILY_DIR}\n"
		exit 1
	fi
	local ARRAY_NAME="${2}"
	declare -n ARRAY="${ARRAY_NAME}"
	for RECIPE_DIR in $(find "${RECIPE_FAMILY_DIR}"/* -type d -exec readlink -f {} \;); do
		RECIPE_DIR_NAME=$(basename "${RECIPE_DIR}")
		if [[ ! "${RECIPE_DIR_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			continue
		fi
		ARRAY+=( "${RECIPE_DIR}" )
	done
}

select_recipes_and_fill_array_with_recipe_directory(){
	if [[ $# -ne 2 ]]; then
		printf "select_recipes_and_fill_array_with_recipe_directory() expects INPUT_ARRAY_NAME and OUTPUT_ARRAY_NAME in argument\n"
		exit 1
	fi
	local INPUT_ARRAY_NAME="${1}"
	declare -n INPUT_ARRAY="${INPUT_ARRAY_NAME}"
	local OUTPUT_ARRAY_NAME="${2}"
	declare -n OUTPUT_ARRAY="${OUTPUT_ARRAY_NAME}"
	OUTPUT_ARRAY=()
	declare -A RECIPE_DISPLAY_NAME_MAP
	WHIPTAIL_CHECKLIST_ARRAY=()
	for RECIPE_DIR in "${INPUT_ARRAY[@]}"; do
		RECIPE_DISPLAY_NAME="$(retrieve_recipe_display_name_from_recipe_directory ${RECIPE_DIR})"
		RECIPE_DISPLAY_NAME_MAP[${RECIPE_DISPLAY_NAME}]="${RECIPE_DIR}"
		WHIPTAIL_CHECKLIST_ARRAY+=( "${RECIPE_DISPLAY_NAME}" "" ON )
	done
	SELECTED_RECIPES=$(whiptail --separate-output --title "Felix" --checklist "Choose recipes to execute" 28 78 20 "${WHIPTAIL_CHECKLIST_ARRAY[@]}" 3>&1 1>&2 2>&3)
	EXIT_CODE=$?
	if [[ $EXIT_CODE = 0 ]]; then
		while read RECIPE_DISPLAY_NAME; do
			OUTPUT_ARRAY+=( "${RECIPE_DISPLAY_NAME_MAP[${RECIPE_DISPLAY_NAME}]}" )
		done <<< "${SELECTED_RECIPES}"
	fi
}

retrieve_recipe_display_name_from_recipe_directory(){
	if [[ $# -ne 1 ]]; then
		printf "retrieve_recipe_display_name_from_recipe_directory() expects RECIPE_DIR in argument\n"
		exit 1
	fi
	RECIPE_DIRECTORY="${1}"
	if [[ ! -d "${RECIPE_DIR}" ]]; then
		printf "Cannot find RECIPE_DIR: ${RECIPE_DIR}\n"
		exit 1
	fi
	RECIPE_DIR_NAME="$(basename "${RECIPE_DIR}")"
	if [[ ! "${RECIPE_DIR_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
		printf "RECIPE_DIR_NAME is not well formed: ${RECIPE_DIR_NAME}\n"
		exit 1
	fi
	RECIPE_NAME="${BASH_REMATCH[3]}"
	RECIPE_DISPLAY_NAME="$(echo "${RECIPE_NAME}"|tr '_' ' ')"
	printf "${RECIPE_DISPLAY_NAME}"
}

list_recipes(){
	if [[ $# -ne 1 ]]; then
		printf "list_recipes() expects RECIPES_PARENT_DIRECTORY in parameter\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY }\n"
		exit 1
	fi
	
	# Retrieve array of recipes
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_PATH_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NAME_REGEX}" -exec readlink -f {} \;|sort)
	
	# List the recipes
	printf "Recipes found:\n"
	for RECIPE_PATH in "${RECIPE_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_PATH})
		
		if [[ ! "${RECIPE_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			printf "\tRECIPE_NAME is not well formed: ${RECIPE_NAME} => it will be ignored!\n"
			continue
		fi
		
		printf "  ${RECIPE_NAME}\n"
		
		RECIPE_ID="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}"
		RECIPE_SCRIPT_FILE_PATH="${RECIPES_PARENT_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}"
		
		#printf "    RECIPE_NAME: ${RECIPE_NAME}\n"
		#printf "    RECIPE_ID: ${RECIPE_ID}\n"
		#printf "    RECIPE_REQUIRED_RIGHTS: ${RECIPE_REQUIRED_RIGHTS}\n"
		#printf "    RECIPE_SCRIPT_FILE_NAME: ${RECIPE_SCRIPT_FILE_NAME}\n"
		#printf "    RECIPE_SCRIPT_FILE_PATH: ${RECIPE_SCRIPT_FILE_PATH}\n"
	done
}

re_index_recipes(){
	if [[ $# -ne 1 ]]; then
		printf "re_index_recipes() expects RECIPES_PARENT_DIRECTORY in argument\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY }\n"
		exit 1
	fi
	
	# Retrieve array of recipes
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_PATH_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NAME_REGEX}" -exec readlink -f {} \;|sort)
	
	# Re-index the recipes
	ID=0
	ID_INCREMENT=10
	for RECIPE_PATH in "${RECIPE_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_PATH})
		
		if [[ ! "${RECIPE_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			printf "\tRECIPE_NAME is not well formed: ${RECIPE_NAME} => it will be ignored!\n"
			continue
		fi
		
		RECIPE_ID="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}"
		RECIPE_SCRIPT_FILE_PATH="${RECIPES_PARENT_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}"
		
		if [[ $((10#${RECIPE_ID})) -ge 9000 ]]; then
			continue;
		fi
		
		ID=$(( "${ID}" + "${ID_INCREMENT}" ))
		RECIPE_NEW_ID=$(printf "%04d" ${ID})
		RECIPE_NEW_NAME="${RECIPE_NEW_ID}-${RECIPE_REQUIRED_RIGHTS}-${RECIPE_SCRIPT_FILE_NAME}"
		
		if [[ "${RECIPE_NAME}" = "${RECIPE_NEW_NAME}" ]]; then
			continue
		fi
		
		mv "${RECIPE_PATH}" "$(dirname ${RECIPE_PATH})/${RECIPE_NEW_NAME}"
	done
}

check_ubuntu_version(){
	LSB_RELEASE_FILE="/etc/lsb-release"
	if [[ ! -f "${LSB_RELEASE_FILE}" ]]; then
		echo "Cannot find file: ${LSB_RELEASE_FILE}"
		echo "Cannot check Ubuntu version"
		exit 1
	fi
	if ! grep -Fq "${SUPPORTED_UBUNTU_VERSION}" "${LSB_RELEASE_FILE}"; then
		echo "This script has not been tested with:"
		cat "${LSB_RELEASE_FILE}"
		exit 1
	fi
	echo "Check Ubuntu version: ${SUPPORTED_UBUNTU_VERSION} => OK"
}

init_recipe(){
	declare -g RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
	declare -g RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
	if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
		printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
		exit 1
	fi
	source "${RECIPE_FAMILY_CONF_FILE}"
	declare -g LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
	printf "FELIX_ROOT=${FELIX_ROOT}\n"
	printf "RECIPE_FAMILY_DIR=${RECIPE_FAMILY_DIR}\n"
	printf "RECIPE_FAMILY_CONF_FILE=${RECIPE_FAMILY_CONF_FILE}\n"
	printf "RECIPE_DIR=${RECIPE_DIR}\n"
	printf "LOGFILE=${LOGFILE}\n"
}
