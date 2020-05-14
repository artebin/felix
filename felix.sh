#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE})/common.sh"

FELIX_BANNER='  __      _ _      
 / _| ___| (_)_  __
| |_ / _ \ | \ \/ /
|  _|  __/ | |>  < 
|_|  \___|_|_/_/\_\'

RECIPE_ID_REGEX="([0-9][0-9][0-9][0-9])-([a-z]+)-([us])-(.*)"
RECIPE_ID_REGEX_GROUP_NUMBER_INDEX=1
RECIPE_ID_REGEX_GROUP_CATEGORY_INDEX=2
RECIPE_ID_REGEX_GROUP_RIGHTS_INDEX=3
RECIPE_ID_REGEX_GROUP_NAME_INDEX=4
RECIPE_CATEGORY_DEFAULT="d"

retrieve_recipe_number(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_NUMBER="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_NUMBER_INDEX}]}"
	printf "${RECIPE_NUMBER}"
}

retrieve_recipe_category(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_CATEGORY="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_CATEGORY_INDEX}]}"
	printf "${RECIPE_CATEGORY}"
}

retrieve_recipe_rights(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_RIGHTS="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_RIGHTS_INDEX}]}"
	printf "${RECIPE_RIGHTS}"
}

retrieve_recipe_name(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_NAME="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_NAME_INDEX}]}"
	printf "${RECIPE_NAME}"
}

retrieve_recipe_display_name(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_NAME="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_NAME_INDEX}]}"
	RECIPE_DISPLAY_NAME="$(echo "${RECIPE_NAME}"|tr '_' ' ')"
	printf "${RECIPE_DISPLAY_NAME}"
}

retrieve_recipe_script_file(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_ID in argument\n"
		exit 1
	fi
	RECIPE_ID="${1}"
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n"
		exit 1
	fi
	RECIPE_NAME="${BASH_REMATCH[${RECIPE_ID_REGEX_GROUP_NAME_INDEX}]}"
	RECIPE_SCRIPT_FILE="${RECIPE_NAME}.sh"
	printf "${RECIPE_SCRIPT_FILE}"
}

list_recipes(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPES_PARENT_DIRECTORY in argument\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY[%s]\n" "${RECIPES_PARENT_DIRECTORY}"
		exit 1
	fi
	
	# Retrieve array of recipes
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_DIRECTORY_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_ID_REGEX}" -exec readlink -f {} \;|sort)
	
	# List the recipes
	printf "Recipes found:\n"
	for RECIPE_DIRECTORY in "${RECIPE_DIRECTORY_ARRAY[@]}"; do
		RECIPE_ID=$(basename "${RECIPE_DIRECTORY}")
		
		if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "\tRECIPE_ID[%s] is not well formed => it will be ignored!\n" "${RECIPE_ID}"
			continue
		fi
		
		printf "# ${RECIPE_ID}\n"
		
		RECIPE_NUMBER=$(retrieve_recipe_number "${RECIPE_ID}")
		RECIPE_CATEGORY=$(retrieve_recipe_category "${RECIPE_ID}")
		RECIPE_RIGHTS=$(retrieve_recipe_rights "${RECIPE_ID}")
		RECIPE_NAME=$(retrieve_recipe_name "${RECIPE_ID}")
		RECIPE_DISPLAY_NAME=$(retrieve_recipe_display_name "${RECIPE_ID}")
		RECIPE_SCRIPT_FILE_PATH=$(retrieve_recipe_script_file "${RECIPE_ID}")
		
		printf "  %-30s: %s\n" "RECIPE_ID" "${RECIPE_ID}"
		printf "  %-30s: %s\n" "RECIPE_NUMBER" "${RECIPE_NUMBER}"
		printf "  %-30s: %s\n" "RECIPE_CATEGORY" "${RECIPE_CATEGORY}"
		printf "  %-30s: %s\n" "RECIPE_RIGHTS" "${RECIPE_RIGHTS}"
		printf "  %-30s: %s\n" "RECIPE_NAME" "${RECIPE_NAME}"
		printf "  %-30s: %s\n" "RECIPE_DISPLAY_NAME" "${RECIPE_DISPLAY_NAME}"
		printf "  %-30s: %s\n" "RECIPE_SCRIPT_FILE_PATH" "${RECIPE_SCRIPT_FILE_PATH}"
	done
}

re_index_recipes(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPES_PARENT_DIRECTORY in argument\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY[%s]\n" "${RECIPES_PARENT_DIRECTORY}"
		exit 1
	fi
	
	# Retrieve array of recipes
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_DIRECTORY_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_ID_REGEX}" -exec readlink -f {} \;|sort)
	
	# Re-index the recipes
	CURRENT_RECIPE_NUMBER=0
	RECIPE_NUMBER_INCREMENT=10
	for RECIPE_DIRECTORY in "${RECIPE_DIRECTORY_ARRAY[@]}"; do
		RECIPE_ID=$(basename ${RECIPE_DIRECTORY})
		
		if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "\tRECIPE_ID[%s] is not well formed => it will be ignored!\n" "${RECIPE_ID}"
			continue
		fi
		
		printf "# ${RECIPE_ID}\n"
		
		RECIPE_NUMBER=$(retrieve_recipe_number "${RECIPE_ID}")
		RECIPE_CATEGORY=$(retrieve_recipe_category "${RECIPE_ID}")
		RECIPE_RIGHTS=$(retrieve_recipe_rights "${RECIPE_ID}")
		RECIPE_NAME=$(retrieve_recipe_name "${RECIPE_ID}")
		RECIPE_DISPLAY_NAME=$(retrieve_recipe_display_name "${RECIPE_ID}")
		RECIPE_SCRIPT_FILE_PATH=$(retrieve_recipe_script_file "${RECIPE_ID}")
		
		# Ignore all recipes with number above 9000
		if [[ $((10#${RECIPE_NUMBER})) -ge 9000 ]]; then
			printf "  => RECIPE_NUMBER greater or equal to 9000 are ignored\n\n"
			continue;
		fi
		
		CURRENT_RECIPE_NUMBER=$(( 10#"${CURRENT_RECIPE_NUMBER}" + "${RECIPE_NUMBER_INCREMENT}" ))
		CURRENT_RECIPE_NUMBER=$(printf "%04d" ${CURRENT_RECIPE_NUMBER})
		RECIPE_NEW_ID="${CURRENT_RECIPE_NUMBER}-${RECIPE_CATEGORY}-${RECIPE_RIGHTS}-${RECIPE_NAME}"
		
		if [[ "${RECIPE_ID}" = "${RECIPE_NEW_ID}" ]]; then
			printf "  => no changes\n\n"
		else
			printf "  => renamed with RECIPE_ID[%s]\n\n" "${RECIPE_NEW_ID}"
			mv "${RECIPES_PARENT_DIRECTORY}/${RECIPE_ID}" "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NEW_ID}"
		fi
	done
}

fill_recipe_directories_array(){
	if [[ $# -ne 2 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPES_PARENT_DIRECTORY and ARRAY_NAME in arguments\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY[%s]\n" "${RECIPES_PARENT_DIRECTORY}"
		exit 1
	fi
	
	# Retrieve and fill array of recipes
	RECIPE_DIRECTORY_ARRAY_NAME="${2}"
	declare -n RECIPE_DIRECTORY_ARRAY="${RECIPE_DIRECTORY_ARRAY_NAME}"
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_DIRECTORY_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_ID_REGEX}" -exec readlink -f {} \;|sort)
}

filter_recipe_directories_array_by_category(){
	if [[ $# -ne 2 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_DIRECTORY_ARRAY_NAME and RECIPE_CATEGORY_TO_MATCH in arguments\n"
		exit 1
	fi
	
	# Retrieve recipe directories
	RECIPE_DIRECTORY_ARRAY_NAME="${1}"
	declare -n RECIPE_DIRECTORY_ARRAY="${RECIPE_DIRECTORY_ARRAY_NAME}"
	
	# Retrive recipe category
	RECIPE_CATEGORY_TO_MATCH="${2}"
	
	# If RECIPE_CATEGORY_TO_MATCH is empty then nothing to do
	if [[ -z "${RECIPE_CATEGORY_TO_MATCH}" ]]; then
		return;
	fi
	
	# Filter RECIPE_DIRECTORY_ARRAY into a local array
	FILTERED_RECIPE_DIRECTORY_ARRAY=()
	for RECIPE_DIRECTORY in "${RECIPE_DIRECTORY_ARRAY[@]}"; do
		RECIPE_ID=$(basename "${RECIPE_DIRECTORY}")
		if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "\tRECIPE_ID[%s] is not well formed => it will be ignored!\n" "${RECIPE_ID}"
			continue
		fi
		RECIPE_CATEGORY=$(retrieve_recipe_category "${RECIPE_ID}")
		if [[ "${RECIPE_CATEGORY}" = "${RECIPE_CATEGORY_TO_MATCH}" ]]; then
			FILTERED_RECIPE_DIRECTORY_ARRAY+=( "${RECIPE_DIRECTORY}" )
		fi
	done
	
	# Copy FILTERED_RECIPE_DIRECTORY_ARRAY into RECIPE_DIRECTORY_ARRAY
	RECIPE_DIRECTORY_ARRAY=("${FILTERED_RECIPE_DIRECTORY_ARRAY[@]}")
}

select_from_recipe_directories_array(){
	if [[ $# -ne 2 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_DIRECTORY_ARRAY_NAME and SELECTED_RECIPE_DIRECTORY_ARRAY_NAME in arguments\n"
		exit 1
	fi
	
	# Retrieve recipe directories
	RECIPE_DIRECTORY_ARRAY_NAME="${1}"
	declare -n RECIPE_DIRECTORY_ARRAY="${RECIPE_DIRECTORY_ARRAY_NAME}"
	
	# Prepare whiptail data, in particular we want display name of recipes
	declare -A RECIPE_DISPLAY_NAME_MAP
	WHIPTAIL_CHECKLIST_ARRAY=()
	for RECIPE_DIRECTORY in "${RECIPE_DIRECTORY_ARRAY[@]}"; do
		RECIPE_ID=$(basename "${RECIPE_DIRECTORY}")
		RECIPE_DISPLAY_NAME="$(retrieve_recipe_display_name ${RECIPE_ID})"
		RECIPE_DISPLAY_NAME_MAP[${RECIPE_DISPLAY_NAME}]="${RECIPE_DIRECTORY}"
		WHIPTAIL_CHECKLIST_ARRAY+=( "${RECIPE_DISPLAY_NAME}" "" ON )
	done
	
	# Retrieve selected recipe directories and clear it
	SELECTED_RECIPE_DIRECTORY_ARRAY_NAME="${2}"
	declare -n SELECTED_RECIPE_DIRECTORY_ARRAY="${SELECTED_RECIPE_DIRECTORY_ARRAY_NAME}"
	SELECTED_RECIPE_DIRECTORY_ARRAY=()
	
	# Call the whiptail
	SELECTED_RECIPE_DISPLAY_NAME_ARRAY=$(whiptail --separate-output --title "Felix" --checklist "Choose recipes to execute" 28 78 20 "${WHIPTAIL_CHECKLIST_ARRAY[@]}" 3>&1 1>&2 2>&3)
	EXIT_CODE=$?
	if [[ ${EXIT_CODE} = 0 ]]; then
		while read RECIPE_DISPLAY_NAME; do
			SELECTED_RECIPE_DIRECTORY_ARRAY+=( "${RECIPE_DISPLAY_NAME_MAP[${RECIPE_DISPLAY_NAME}]}" )
		done <<< "${SELECTED_RECIPE_DISPLAY_NAME_ARRAY}"
	fi
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
	printf "\n"
}

retrieve_log_file_name(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects FILE_NAME in argument\n"
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
