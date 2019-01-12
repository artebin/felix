#!/usr/bin/env bash

source ./xubuntu_18.04.sh
is_bash

list_recipes(){
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

execute_recipes(){
	printf "Executing recipes ...\n"
	printf "Interactive mode=${INTERACTIVE_MODE}\n\n"
	
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
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}.sh"
		RECIPE_SCRIPT_FILE_PATH="${RECIPE_PATH}/${RECIPE_SCRIPT_FILE_NAME}"
		
		# Check recipe script exists
		if [ ! -f "${RECIPE_SCRIPT_FILE_PATH}" ]; then
			echo "Can not find script for recipe: ${RECIPE_SCRIPT_FILE_PATH}"
			print_section_ending
			continue
		fi
		
		EXECUTION_EXPECTED="true"
		
		# Interactive mode?
		if [ "${INTERACTIVE_MODE}" == "true" ]; then
			USER_ANSWER=$(yes_no_dialog "Execute this recipe?")
			if [ "${USER_ANSWER}" != "yes" ]; then
				EXECUTION_EXPECTED="false"
			fi
		fi
		
		if [ "${EXECUTION_EXPECTED}" == "true" ]; then
			cd "${RECIPE_PATH}"
			
			# Execute the recipe with the required rights
			RECIPE_EXIT_CODE=0
			if [ "${RECIPE_REQUIRED_RIGHTS}" = "u" ]; then
				bash "./${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXIT_CODE=$?
			elif [ "${RECIPE_REQUIRED_RIGHTS}" = "s" ]; then
				sudo -H bash "./${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXIT_CODE=$?
			else
				echo "Can not retrieve execution rights for RECIPE_NAME: ${RECIPE_NAME}"
			fi
			
			# Stop execution of the recipes if current recipe return an error code
			if [ "${RECIPE_EXIT_CODE}" -ne 0 ]; then
				echo "Recipe \"${RECIPE_NAME}\" returned an error code."
				echo "Exiting."
				exit 1
			fi
		fi
		
		print_section_ending
	done
}

print_usage(){
	printf "Usage: bash install.sh [OPTION...] <recipes parent directory>\n\n"
	printf -- "  -i interactive mode\n"
}

# Retrieve options
INTERACTIVE_MODE="false"
while getopts ":i" OPT; do
	case "${OPT}" in
		i)
			INTERACTIVE_MODE="true"
			;;
		*)
			print_usage
			;;
	esac
done
shift $((OPTIND-1))

# Only one argument is allowed and it is the parent directory for recipes
if [ $# -ne 1 ]; then
	print_usage
	exit 1
fi
RECIPES_PARENT_DIRECTORY="${1}"

# Check existence of the parent directory for recipes
if [ ! -d "${RECIPES_PARENT_DIRECTORY}" ]; then
	echo "Can not find RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}"
	print_usage
	exit 1
fi

# Retrieve array of recipes
RECIPES_PARENT_DIRECTORY=$(readlink -f "${RECIPES_PARENT_DIRECTORY}")
readarray -t RECIPE_PATH_ARRAY < <(find "${RECIPES_PARENT_DIRECTORY}" -maxdepth 1 -type d -regextype posix-extended -regex "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NAME_REGEX}" -exec readlink -f {} \;|sort)

# Exit if no recipe found
if [ "${#RECIPE_PATH_ARRAY[@]}" -eq 0 ]; then
	echo "No recipes found in RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}"
	exit 0
fi

# Check Xubuntu version
if ! check_xubuntu_version; then
	exit 1
fi

# List recipes
printf "RECIPES_PARENT_DIRECTORY: ${RECIPES_PARENT_DIRECTORY}\n"
echo
list_recipes

# Ask user to continue
echo
USER_ANSWER=$(yes_no_dialog "Continue?")
if [ "${USER_ANSWER}" != "yes" ]; then
	echo "Exiting."
	exit 0
fi
echo

# Execute the recipes
execute_recipes 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
