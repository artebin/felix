#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE})/felix.sh"

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

execute_recipes_from_recipe_directory_array(){
	if [[ $# -ne 2 ]]; then
		printf "execute_recipes_from_recipe_directory_array() expects ARRAY_NAME and ASK_CONFIRMATION as argument\n"
		exit 1
	fi
	
	local ARRAY_NAME="${1}"
	declare -n RECIPE_DIR_ARRAY="${ARRAY_NAME}"
	
	local ASK_CONFIRMATION="${2}"
	if [[  "${ASK_CONFIRMATION}" != 'true' && "${ASK_CONFIRMATION}" != 'false' ]]; then
		printf "ASK_CONFIRMATION should be valued 'true' or 'false'"
		exit 1
	fi
	
	printf "Executing recipes ...\n"
	printf "ASK_CONFIRMATION: ${ASK_CONFIRMATION}\n\n"
	
	for RECIPE_DIR in "${RECIPE_DIR_ARRAY[@]}"; do
		RECIPE_DIR_NAME=$(basename ${RECIPE_DIR})
		print_section_heading "RECIPE_DIR_NAME: ${RECIPE_DIR_NAME}"
		
		if [[ ! "${RECIPE_DIR_NAME}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "RECIPE_DIR_NAME is not well formed: ${RECIPE_DIR_NAME}\n"
			exit 1
		fi
		
		RECIPE_EXECUTION_FAILED=0
		
		RECIPE_NUMBER="${BASH_REMATCH[1]}"
		RECIPE_REQUIRED_RIGHTS="${BASH_REMATCH[2]}"
		RECIPE_SCRIPT_FILE_NAME="${BASH_REMATCH[3]}.sh"
		RECIPE_SCRIPT_FILE="${RECIPE_DIR}/${RECIPE_SCRIPT_FILE_NAME}"
		
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
			cd "${RECIPE_DIR}"
			
			# Execute the recipe with the required rights
			RECIPE_EXIT_CODE=0
			if [[ "${RECIPE_REQUIRED_RIGHTS}" == "u" ]]; then
				bash "${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXECUTION_FAILED=$?
			elif [[ "${RECIPE_REQUIRED_RIGHTS}" == "s" ]]; then
				sudo -H bash "${RECIPE_SCRIPT_FILE_NAME}"
				RECIPE_EXECUTION_FAILED=$?
			else
				echo "Unknown execution rights \'${RECIPE_REQUIRED_RIGHTS}\' for RECIPE_DIR_NAME: ${RECIPE_DIR_NAME}"
			fi
		fi
		
		print_section_ending
		
		# Stop looping over RECIPE_DIR_ARRAY if the execution of the current recipe return an error code
		if [[ "${RECIPE_EXECUTION_FAILED}" -ne 0 ]]; then
			printf "Recipe '${RECIPE_DIR_NAME}' returned an error code.\n"
			printf "Exiting.\n"
			exit 1
		fi
	done
}

print_usage(){
	printf "Usage: bash ${0} [OPTIONS...] RECIPE_FAMILY_DIR\n"
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

# Only one argument is allowed and it is the RECIPE_FAMILY_DIR
if [[ $# -ne 1 ]]; then
	print_usage
	exit 1
fi
RECIPE_FAMILY_DIR="${1}"

# Check existence of RECIPE_FAMILY_DIR
if [[ ! -d "${RECIPE_FAMILY_DIR}" ]]; then
	printf "Cannot find RECIPE_FAMILY_DIR: ${RECIPE_FAMILY_DIR}\n"
	print_usage
	exit 1
fi

printf "${FELIX_BANNER}"
printf "\n\n"
printf "RECIPE_FAMILY_DIR: ${RECIPE_FAMILY_DIR}\n"
if ! check_ubuntu_version; then
	exit 1
fi
printf "\n"

# Retrieve array of RECIPE_DIR
RECIPE_DIR_TO_EXECUTE_ARRAY=()
fill_array_with_recipe_directory_from_recipe_family_directory "${RECIPE_FAMILY_DIR}" "RECIPE_DIR_TO_EXECUTE_ARRAY"
if ${SHOW_DIALOG_SELECT_RECIPES}; then
	SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY=()
	select_recipes_and_fill_array_with_recipe_directory "RECIPE_DIR_TO_EXECUTE_ARRAY" "SELECTED_RECIPE_DIR_TO_EXECUTE_ARRAY"
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
execute_recipes_from_recipe_directory_array "RECIPE_DIR_TO_EXECUTE_ARRAY" "${ASK_CONFIRMATION}" 2>&1 | tee -a "${LOGFILE}"
