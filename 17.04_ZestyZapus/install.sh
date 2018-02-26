#!/bin/bash

source ./common.sh
check_shell

print_usage(){
	echo "Usage: bash install.sh <recipes parent directory>"
}

if [ $# -ne 1 ]; then
	print_usage
	exit 1
fi

RECIPES_PARENT_DIRECTORY="${1}"
if [ ! -d "${RECIPES_PARENT_DIRECTORY}" ]; then
	echo "Can not find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}"
	print_usage
	exit 1
fi

RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
readarray -t RECIPE_PATH_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NAME_REGEX}" -exec readlink -f {} \;|sort)

list_recipes(){
	printf "Recipes found:\n"
	for RECIPE_PATH in "${RECIPE_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_PATH})
		
		if [[ ! "${RECIPE_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			printf "\tRECIPE_NAME is not well formed: ${RECIPE_NAME} => it will be ignored!\n"
			continue
		fi
		
		printf "\t${RECIPE_NAME}\n"
		
		RECIPE_ID="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}"
		RECIPE_SCRIPT_FILE_PATH="${RECIPES_PARENT_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}"
		
		#printf "\t\tRECIPE_NAME: ${RECIPE_NAME}\n"
		#printf "\t\tRECIPE_ID: ${RECIPE_ID}\n"
		#printf "\t\tRECIPE_REQUIRED_RIGHTS: ${RECIPE_REQUIRED_RIGHTS}\n"
		#printf "\t\tRECIPE_SCRIPT_FILE_NAME: ${RECIPE_SCRIPT_FILE_NAME}\n"
		#printf "\t\tRECIPE_SCRIPT_FILE_PATH: ${RECIPE_SCRIPT_FILE_PATH}\n"
	done
}

execute_recipes(){
	for RECIPE_PATH in "${RECIPE_PATH_ARRAY[@]}"; do
		RECIPE_NAME=$(basename ${RECIPE_PATH})
		print_section_heading "RECIPE_NAME: ${RECIPE_NAME}"
		
		if [[ ! "${RECIPE_NAME}" =~ ${RECIPE_NAME_REGEX} ]]; then
			echo "RECIPE_NAME is not well formed: ${RECIPE_NAME}"
			print_section_ending
			continue
		fi
		
		RECIPE_ID="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}"
		RECIPE_SCRIPT_FILE_PATH="${RECIPES_PARENT_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}.sh"
		
		if [ ! -f "${RECIPE_SCRIPT_FILE_PATH}" ]; then
			echo "Can not find script for recipe: ${RECIPE_SCRIPT_FILE_PATH}"
			print_section_ending
			continue
		fi
		
		cd "${RECIPES_PARENT_DIRECTORY}"
		
		# Execute the recipe with the required rights
		if [ "${RECIPE_REQUIRED_RIGHTS}" = "U" ]; then
			bash "./${RECIPE_SCRIPT_FILE_NAME}"
		elif [ "${RECIPE_REQUIRED_RIGHTS}" = "S" ]; then
			sudo bash "./${RECIPE_SCRIPT_FILE_NAME}"
		else
			echo "Can not retrieve execution rights for RECIPE_NAME: ${RECIPE_NAME}"
		fi
		print_section_ending
	done
}

if ! check_xubuntu_version; then
	exit 1
fi

printf "RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}\n"

if [ "${#RECIPE_PATH_ARRAY[@]}" -eq 0 ]; then
	echo "No recipes found in RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}"
	exit 0
fi

echo
list_recipes
echo

while true; do
	read -p "Continue? [y/n] " USER_ANSWER
	case "${USER_ANSWER}" in
		[Yy]* )
			printf "\n"
			execute_recipes 
			break
			;;
		[Nn]* ) 
			exit
			;;
		* ) 
			printf "Please answer yes or no\n\n"
			;;
	esac
done
