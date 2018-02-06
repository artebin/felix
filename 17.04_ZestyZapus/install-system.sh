#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
	printf 'This script should run with bash\n' 1>&2
	exit 1
fi

source ./common.sh

readarray -t RECIPE_DIRECTORY_PATH_ARRAY < <(find ./system/ -maxdepth 1 -type d -regex ".*/[0-9][0-9][0-9][0-9]-.*" -exec readlink -f {} \;|sort)

list_all_system_recipes(){
	printf '\nRecipes to be used:\n'
	for RECIPE_DIRECTORY_PATH in "${RECIPE_DIRECTORY_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_DIRECTORY_PATH})
		printf "\t${RECIPE_NAME}\n"
	done
	printf '\n'
}

execute_all_system_recipes(){
	for RECIPE_DIRECTORY_PATH in "${RECIPE_DIRECTORY_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_DIRECTORY_PATH})
		
		# The script to execute is derived from the recipe name
		SCRIPT_FILE_NAME=$(echo "${RECIPE_NAME}"|sed 's/^[0-9][0-9][0-9][0-9]-//').sh
		SCRIPT_FILE_PATH="${RECIPE_DIRECTORY_PATH}/${SCRIPT_FILE_NAME}"
		
		printf "RECIPE_NAME: ${RECIPE_NAME}\n"
		
		if [[ ! -f "${SCRIPT_FILE_PATH}" ]]; then
			printf "Can not find script for recipe: ${RECIPE_NAME}\n\n"
			continue
		fi
		
		printf "\t=> ${SCRIPT_FILE_NAME}\n" 
		
		cd "${RECIPE_DIRECTORY_PATH}"
		SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
		sudo bash "./${SCRIPT_FILE_NAME}"
		
		printf '\n'
	done
}

if ! check_xubuntu_version; then
	exit 1
fi

list_all_system_recipes

while true; do
	read -p "Continue? [y/n] " USER_ANSWER
	case "${USER_ANSWER}" in
		[Yy]* )
			printf '\n'
			execute_all_system_recipes 
			break
			;;
		[Nn]* ) 
			exit
			;;
		* ) 
			printf 'Please answer yes or no\n\n'
			;;
	esac
done
