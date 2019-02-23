#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE})/common.sh"

FELIX_BANNER='  __      _ _      
 / _| ___| (_)_  __
| |_ / _ \ | \ \/ /
|  _|  __/ | |>  < 
|_|  \___|_|_/_/\_\'

retrieve_log_file_name(){
	if [[ $# -ne 1 ]]; then
		printf "Function retrieve_log_file_name() expects FILE_NAME in parameter\n"
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
		printf "Function retrieve_recipe_family_dir() expects RECIPE_DIR in parameter\n"
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
		printf "Function retrieve_recipe_family_conf_file() expects RECIPE_DIR in parameter\n"
		exit 1
	fi
	FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_DIR##*/felix/}"
	RECIPE_FAMILY_DIR_NAME="${RECIPE_FAMILY_DIR_NAME%%/*}"
	RECIPE_FAMILY_DIR="${FELIX_ROOT}/${RECIPE_FAMILY_DIR_NAME}"
	printf "${RECIPE_FAMILY_DIR}/${RECIPE_FAMILY_DIR_NAME}.conf"
}

RECIPE_NAME_REGEX="([0-9][0-9][0-9][0-9])-([us])-(.*)"

list_recipes(){
	if [[ $# -ne 1 ]]; then
		printf "Function list_recipes() expects RECIPES_PARENT_DIRECTORY in parameter\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY }\n"
		printf "\n"
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
		printf "\n"
		exit 1
	fi
	RECIPES_PARENT_DIRECTORY="${1}"
	if [[ ! -d "${RECIPES_PARENT_DIRECTORY}" ]]; then
		printf "Cannot find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY }\n"
		printf "\n"
		exit 1
	fi
	
	# Retrieve array of recipes
	RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
	readarray -t RECIPE_PATH_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NAME_REGEX}" -exec readlink -f {} \;|sort)
	
	# Re-index the recipes
	ID=0
	ID_INCREMENT=10
	for RECIPE_PATH in "${RECIPE_PATH_ARRAY[@]}"; do
		ID=$(( "${ID}" + "${ID_INCREMENT}" ))
		
		RECIPE_NAME=$(basename ${RECIPE_PATH})
		
		if [[ ! "${RECIPE_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			printf "\tRECIPE_NAME is not well formed: ${RECIPE_NAME} => it will be ignored!\n"
			continue
		fi
		
		RECIPE_ID="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}"
		RECIPE_SCRIPT_FILE_PATH="${RECIPES_PARENT_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}"
		
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
		echo
		exit 1
	fi
	if ! grep -Fq "${SUPPORTED_UBUNTU_VERSION}" "${LSB_RELEASE_FILE}"; then
		echo "This script has not been tested with:"
		cat "${LSB_RELEASE_FILE}"
		echo
		exit 1
	fi
	echo "Check Ubuntu version: ${SUPPORTED_UBUNTU_VERSION} => OK"
}
