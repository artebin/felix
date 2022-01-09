#!/usr/bin/env bash

source "felix.sh"

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
INSTALL_LOG_FILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

execute_recipes_from_recipe_directory_array(){
	if [[ $# -ne 2 ]]; then
		printf "execute_recipes_from_recipe_directory_array() expects ARRAY_NAME and ASK_CONFIRMATION as argument\n"
		exit 1
	fi
	
	local ARRAY_NAME="${1}"
	declare -n RECIPE_DIRECTORY_ARRAY="${ARRAY_NAME}"
	
	local ASK_CONFIRMATION="${2}"
	if [[ "${ASK_CONFIRMATION}" != 'true' && "${ASK_CONFIRMATION}" != 'false' ]]; then
		printf "ASK_CONFIRMATION should be valued 'true' or 'false'"
		exit 1
	fi
	
	printf "Executing recipes ...\n"
	printf "ASK_CONFIRMATION: ${ASK_CONFIRMATION}\n\n"
	
	for RECIPE_DIRECTORY in "${RECIPE_DIRECTORY_ARRAY[@]}"; do
		cd "${BASEDIR}"
		
		RECIPE_ID=$(basename ${RECIPE_DIRECTORY})
		print_section_heading "RECIPE_ID: ${RECIPE_ID}"
		
		if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "RECIPE_ID is not well formed: ${RECIPE_ID}\n"
			exit 1
		fi
		
		RECIPE_EXECUTION_FAILED=0
		
		RECIPE_RIGHTS=$(retrieve_recipe_rights "${RECIPE_ID}")
		RECIPE_NAME=$(retrieve_recipe_name "${RECIPE_ID}")
		RECIPE_SCRIPT_FILE_NAME=$(retrieve_recipe_script_file "${RECIPE_ID}")
		RECIPE_SCRIPT_FILE="${RECIPE_DIRECTORY}/${RECIPE_SCRIPT_FILE_NAME}"
		
		# Check recipe script exists
		if [[ ! -f "${RECIPE_SCRIPT_FILE}" ]]; then
			echo "Cannot find RECIPE_SCRIPT_FILE: ${RECIPE_SCRIPT_FILE}"
			print_section_ending
			continue
		fi
		
		EXECUTION_EXPECTED="true"
		
		# Ask confirmation
		if ${ASK_CONFIRMATION}; then
			USER_ANSWER=$(yes_no_dialog "Execute this recipe?")
			if [[ "${USER_ANSWER}" != "yes" ]]; then
				EXECUTION_EXPECTED="false"
			fi
		fi
		
		if ${EXECUTION_EXPECTED}; then
			cd "${RECIPE_DIRECTORY}"
			
			# Execute the recipe with the required rights
			RECIPE_EXIT_CODE=0
			if [[ "${RECIPE_RIGHTS}" == "u" ]]; then
				bash "${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXECUTION_FAILED=$?
			elif [[ "${RECIPE_RIGHTS}" == "s" ]]; then
				sudo -H bash "${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXECUTION_FAILED=$?
			else
				echo "Unknown execution rights \'${RECIPE_RIGHTS}\' for RECIPE_ID: ${RECIPE_ID}"
			fi
		fi
		
		print_section_ending
		
		# Stop looping over RECIPE_DIR_ARRAY if the execution of the current recipe return an error code
		if [[ "${RECIPE_EXECUTION_FAILED}" -ne 0 ]]; then
			printf "Recipe '${RECIPE_ID}' returned an error code.\n"
			printf "Exiting.\n"
			exit 1
		fi
	done
}

print_usage(){
	printf "Usage: bash ${0} [OPTIONS...] RECIPE_LIST_FILE\n"
	printf "  -i show a dialog to select the recipes to execute\n"
	printf "  -c ask for confirmation before recipe execution\n\n"
}

# Retrieve options
SHOW_DIALOG_SELECT_RECIPES="false"
ASK_CONFIRMATION="false"
while getopts ":ic" OPT; do
	case "${OPT}" in
		i)
			SHOW_DIALOG_SELECT_RECIPES="true"
			;;
		c)
			ASK_CONFIRMATION="true"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

# Only one argument is allowed and it is the RECIPE_LIST_FILE
if [[ $# -ne 1 ]]; then
	print_usage
	exit 1
fi
RECIPE_LIST_FILE="${1}"

# Check existence of RECIPE_LIST_FILE
if [[ ! -f "${RECIPE_LIST_FILE}" ]]; then
	printf "ERROR: cannot find RECIPE_LIST_FILE[%s]\n" "${RECIPE_LIST_FILE}"
	print_usage
	exit 1
fi

printf "${FELIX_BANNER}"
printf "\n"
printf "RECIPE_LIST_FILE: ${RECIPE_LIST_FILE}\n"
printf "\n"

# Retrieve array of recipes from recipe list file
RECIPE_DIR_TO_EXECUTE_ARRAY=()
fill_recipe_array_with_recipe_list_file "${RECIPE_LIST_FILE}" "RECIPE_DIR_TO_EXECUTE_ARRAY"

if ${SHOW_DIALOG_SELECT_RECIPES}; then
	SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY=()
	select_from_recipe_directories_array "RECIPE_DIR_TO_EXECUTE_ARRAY" "SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY"
	RECIPE_DIR_TO_EXECUTE_ARRAY="${SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY}"
	RECIPE_DIR_TO_EXECUTE_ARRAY=( "${SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY[@]}" )
fi

# Exit if RECIPE_DIR_TO_EXECUTE_ARRAY is empty
if [[ "${#RECIPE_DIR_TO_EXECUTE_ARRAY[@]}" -eq 0 ]]; then
	printf "No recipes found\n"
	exit 0
fi

# List to be executed
printf "The recipes below will be executed:\n"
for RECIPE_DIR in "${RECIPE_DIR_TO_EXECUTE_ARRAY[@]}"; do
	RECIPE_DIR_NAME="$(basename ${RECIPE_DIR})"
	printf "\t${RECIPE_DIR_NAME}\n"
done

# Ask user confirmation
printf "\n"
USER_ANSWER=$(yes_no_dialog "Continue?")
if [[ "${USER_ANSWER}" != "yes" ]]; then
	printf "User cancelled\n"
	exit 0
fi

# Execute the recipes
execute_recipes_from_recipe_directory_array "RECIPE_DIR_TO_EXECUTE_ARRAY" "${ASK_CONFIRMATION}" 2>&1 | tee -a "${INSTALL_LOG_FILE}"
