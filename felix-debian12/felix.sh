#!/usr/bin/env bash

function exit_if_not_bash(){
	if [[ ! "${BASH_VERSION}" ]] ; then
		printf "This script should run with bash\n" 1>&2
		exit 1
	fi
}

function exit_if_no_x_session(){
	if [[ -z "${DISPLAY}" ]] ; then
		printf "This script should run within a X session\n" 1>&2
		exit 1
	fi
}

function has_root_privileges(){
	if [[ "${EUID}" -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

function exit_if_has_not_root_privileges(){
	if ! has_root_privileges; then
		printf "This script needs the root priveleges\n" 1>&2
		exit 1
	fi
}

function exit_if_has_root_privileges(){
	if has_root_privileges; then
		printf "This script should not be executed with the root priveleges\n" 1>&2
		exit 1
	fi
}

function escape_sed_pattern(){
	printf "${1}" | sed -e 's/[\\&]/\\&/g' | sed -e 's/[\/&]/\\&/g'
}

function update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
		return 0
	else
		return 1
	fi
}

function add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${FILE_PATH}"
	fi
}

function add_or_update_keyvalue(){
	FILE_PATH="${1}"
	KEY="${2}"
	NEW_VALUE="${3}"
	ESCAPED_KEY=$(escape_sed_pattern "${KEY}")
	ESCAPED_NEW_VALUE=$(escape_sed_pattern "${NEW_VALUE}")
	if grep -q "^${ESCAPED_KEY}" "${FILE_PATH}"; then
		sed -i "/^${ESCAPED_KEY}=/s/.*/${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}/" "${FILE_PATH}"
	else
		echo "${ESCAPED_KEY}=${ESCAPED_NEW_VALUE}" >> "${FILE_PATH}"
	fi
}

function yes_no_dialog(){
	if [ "$#" -ne 1 ]; then
		printf "Function yes_no_dialog() expects one argument\n"
		exit 1
	fi
	DIALOG_TEXT="${1}"
	while true; do
		read -p "${DIALOG_TEXT} [y/n] " USER_ANSWER
		case "${USER_ANSWER}" in
			[Yy]* )
				printf "yes"
				break
				;;
			[Nn]* )
				printf "no"
				break
				;;
			* )
				printf "Please answer yes or no\n\n" > /dev/stderr
				;;
		esac
	done
}

function print_section_heading(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	printf "# ${1}\n"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

function print_section_ending(){
	echo
	echo
	echo
}

function backup_file(){
	if [[ $# -ne 2 ]]; then
		echo "Function backup_file() expects BACKUP_MODE and FILE in parameters"
		exit 1
	fi
	BACKUP_MODE="${1}"
	FILE="${2}"
	if [[ ! -e "${FILE}" ]]; then
		echo "Cannot find FILE: ${FILE}"
		exit 1
	fi
	FILE_BACKUP="${FILE}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${BACKUP_MODE}" in
		"rename")
			mv "${FILE}" "${FILE_BACKUP}"
			if [[ $? -ne 0 ]]; then
				echo "Cannot backup file: ${FILE}"
				exit 1
			fi
			;;
		"copy")
			cp "${FILE}" "${FILE_BACKUP}"
			if [[ $? -ne 0 ]]; then
				echo "Cannot backup file: ${FILE}"
				exit 1
			fi
			;;
		*)
			echo "Unknown BACKUP_MODE: ${BACKUP_MODE}"
			exit 1
	esac
	printf "Created backup of: ${FILE}\n"
}

function backup_by_rename_if_exists_and_copy_replacement(){
	if [[ $# -ne 2 ]]; then
		echo "Function backup_by_rename_if_exists_and_copy_replacement() expects SOURCE and REPLACEMENT in parameters"
		exit 1
	fi
	SOURCE="${1}"
	REPLACEMENT="${2}"
	if [[ -e "${SOURCE}" ]]; then
		backup_file rename "${SOURCE}"
	fi
	cp -r "${REPLACEMENT}" "${SOURCE}"
}

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
function remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

function is_package_available(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	apt-cache --quiet=0 showpkg "${PACKAGE_NAME}" 2>&1|grep -q 'Unable to locate package'
	IS_PACKAGE_NOT_AVAILABLE=$?
	if [[ ${IS_PACKAGE_NOT_AVAILABLE} -eq 0 ]]; then
		return 1
	else
		return 0
	fi
}

function retrieve_package_short_description(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	PACKAGE_DESCRIPTION=$(apt-cache show "${PACKAGE_NAME}"|grep -m 1 "Description-en: "|sed 's/Description-en: //g'|sed 's/^\s\+//g'|sed 's/\s\+$//g')
	printf "${PACKAGE_DESCRIPTION}"
}

function generate_apt_package_list_files(){
	if [[ $# -ne 3 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_LIST_FILE, APT_PACKAGE_LIST_FILE_NAME_PREFIX and MISSING_PACKAGE_LIST_FILE in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_LIST_FILE="${1}"
	APT_PACKAGE_LIST_FILE="${2}"
	MISSING_PACKAGE_LIST_FILE="${3}"
	if [[ ! -f "${PACKAGE_LIST_FILE}" ]]; then
		printf "Cannot find PACKAGE_LIST_FILE[%s]\n" 1>&2 "${PACKAGE_LIST_FILE}"
		exit 1
	fi
	
	# Collect the packages per APT options
	# If APT_OPTIONS is specified in LINE then we creates a package list file especially for this LINE
	declare -A APT_OPTIONS_AND_PACKAGE_LIST_ARRAY
	KEY_APT_OPTIONS="00_NO_APT_APTIONS" # The prefix "00_" will ensure this package list file to be written first
	DEBUG_DEPENDENCIES_FILE="dependencies.txt"
	if [[ -f "${DEBUG_DEPENDENCIES_FILE}" ]]; then
		rm -f "${DEBUG_DEPENDENCIES_FILE}"
	fi
	while read LINE; do
		# Remove extra spaces
		LINE=$(echo "${LINE}"|awk '{$1=$1};1')
		
		# A line can contain a comment starting with the character hash '#'
		# Remove the comment part
		LINE="${LINE%%#*}"
		
		# A line can contain APT options
		APT_OPTIONS="${KEY_APT_OPTIONS}"
		if [[ "${LINE}" == @* ]]; then
			APT_OPTIONS="${LINE%@*}"
			APT_OPTIONS="${APT_OPTIONS:1}"
			LINE="${LINE##*@}"
		fi
		
		# Skip empty lines
		if [[ -z "${LINE}" ]]; then
			continue
		fi
		
		PACKAGES_LINE="${LINE}"
		
		for PACKAGE_NAME in ${PACKAGES_LINE}; do
			IS_PACKAGE_AVAILABLE=$(is_package_available "${PACKAGE_NAME}";echo $?)
			
			# Fill APT_OPTIONS_AND_PACKAGE_LIST_ARRAY or write the missing package in MISSING_PACKAGE_LIST_FILE
			if [[ ${IS_PACKAGE_AVAILABLE} -eq 0 ]]; then
				APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[${APT_OPTIONS}]+="${PACKAGE_NAME} "
			else
				printf "%s\n" "${PACKAGE_NAME}" >> "${MISSING_PACKAGE_LIST_FILE}"
			fi
			
			# Print a report in the console for PACKAGE_NAME
			INFO_AVAILABLE=$'\e[39m\e[0m'
			INFO_INSTALLATION_STATUS=$'\e[39m\e[0m'
			INFO_PACKAGE_DESCRIPTION=""
			if [[ ${IS_PACKAGE_AVAILABLE} -eq 0 ]]; then
				INFO_AVAILABLE=$'\e[92mAVAILABLE\e[0m'
				IS_PACKAGE_INSTALLED=$(is_package_installed "${PACKAGE_NAME}";echo $?)
				if [[ ${IS_PACKAGE_INSTALLED} -eq 0 ]]; then
					INFO_INSTALLATION_STATUS=$'\e[92mINSTALLED\e[0m'
				else
					INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
				fi
				INFO_PACKAGE_DESCRIPTION=$(retrieve_package_short_description "${PACKAGE_NAME}")
			else
				INFO_AVAILABLE=$'\e[91mMISSING\e[0m'
				INFO_INSTALLATION_STATUS=$'\e[39mNOT INSTALLED\e[0m'
			fi
			if [[ ! -z "${INFO_PACKAGE_DESCRIPTION}" ]]; then
				INFO_PACKAGE_DESCRIPTION=": ${INFO_PACKAGE_DESCRIPTION}"
			fi
			printf "[%-25s] [%-25s] %s%s\n" "${INFO_AVAILABLE}" "${INFO_INSTALLATION_STATUS}" "${PACKAGE_NAME}" "${INFO_PACKAGE_DESCRIPTION}"
			
			# Fill DEBUG_DEPENDENCIES_FILE with dependencies of PACKAGE_NAME
			apt-cache depends "${PACKAGE_NAME}" >> "${DEBUG_DEPENDENCIES_FILE}"
		done
	done <"${PACKAGE_LIST_FILE}"
	
	# Write the package list files
	rm -f "./${APT_PACKAGE_LIST_FILE_NAME_PREFIX}*"
	APT_PACKAGE_LIST_INDEX=0
	for APT_OPTIONS in "${!APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[@]}"; do
		APT_PACKAGE_LIST_FILE="${APT_PACKAGE_LIST_FILE_NAME_PREFIX}_${APT_PACKAGE_LIST_INDEX}"
		if [[ "${APT_OPTIONS}" != "${KEY_APT_OPTIONS}" ]]; then
			printf "%s\n" "${APT_OPTIONS}" >"${APT_PACKAGE_LIST_FILE}"
		fi
		for PACKAGE_NAME in ${APT_OPTIONS_AND_PACKAGE_LIST_ARRAY[${APT_OPTIONS}]}; do
			printf "%s\n" "${PACKAGE_NAME}" >>"${APT_PACKAGE_LIST_FILE}"
		done
		((++APT_PACKAGE_LIST_INDEX))
	done
}

function is_package_installed(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects PACKAGE_NAME in arguments\n" 1>&2
		exit 1
	fi
	PACKAGE_NAME="${1}"
	dpkg-query -W -f='${Status}' "${PACKAGE_NAME}" 2>&1|grep -q 'ok installed'
	IS_PACKAGE_INSTALLED=$?
	if [[ ${IS_PACKAGE_INSTALLED} -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

function install_package_if_not_installed(){
	if [[ ! $# -ge 1 ]]; then
		printf "${FUNCNAME[0]}() expects one or several package name in argument\n" 1>&2
		exit 1
	fi
	for PACKAGE_NAME in $@; do
		if $(is_package_installed "${PACKAGE_NAME}"); then
			printf "Package is already installed: ${PACKAGE_NAME}\n"
		else
			printf "Installing package: ${PACKAGE_NAME} ...\n"
			if [[ ${EUID} -ne 0 ]]; then
				printf "Current user is not root => using sudo\n"
				sudo apt-get install -y "${PACKAGE_NAME}"
			else
				apt-get install -y "${PACKAGE_NAME}"
			fi
		fi
	done
}

function remove_with_purge_package_if_installed(){
	if [[ ! $# -ge 1 ]]; then
		printf "Function remove_with_purge_package_if_installed() expects one or several package names in argument\n" 1>&2
		exit 1
	fi
	for PACKAGE_NAME in $@; do
		if ! $(is_package_installed "${PACKAGE_NAME}"); then
			printf "Package not removed because not installed: ${PACKAGE_NAME}\n"
		else
			printf "Removing package: ${PACKAGE_NAME} ...\n"
			apt-get remove --purge -y "${PACKAGE_NAME}"
		fi
	done
}

function key_value_retriever(){
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
	VALUE="$(echo "${VALUE}" | sed "s/\r//g" )"
	export "${VALUE_VARNAME}"="${VALUE}"
}

FELIX_BANNER='
███████ ███████ ██      ██ ██   ██ 
██      ██      ██      ██  ██ ██  
█████   █████   ██      ██   ███   
██      ██      ██      ██  ██ ██  
██      ███████ ███████ ██ ██   ██ 
'

RECIPE_ID_REGEX="([0-9][0-9][0-9][0-9]|x)-([us])-([a-zA-Z0-9_#]*)"
RECIPE_ID_REGEX_GROUP_NUMBER_INDEX=1
RECIPE_ID_REGEX_GROUP_RIGHTS_INDEX=2
RECIPE_ID_REGEX_GROUP_NAME_INDEX=3

function retrieve_recipe_number(){
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

function retrieve_recipe_rights(){
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

function retrieve_recipe_name(){
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

function retrieve_recipe_display_name(){
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

function retrieve_recipe_script_file(){
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
	RECIPE_SCRIPT_FILE="${RECIPE_NAME%%#*}.sh"
	printf "${RECIPE_SCRIPT_FILE}"
}

function list_recipes(){
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
		RECIPE_RIGHTS=$(retrieve_recipe_rights "${RECIPE_ID}")
		RECIPE_NAME=$(retrieve_recipe_name "${RECIPE_ID}")
		RECIPE_DISPLAY_NAME=$(retrieve_recipe_display_name "${RECIPE_ID}")
		RECIPE_SCRIPT_FILE_PATH=$(retrieve_recipe_script_file "${RECIPE_ID}")
		
		printf "  %-40s: %s\n" "RECIPE_ID" "${RECIPE_ID}"
		printf "  %-40s: %s\n" "RECIPE_NUMBER" "${RECIPE_NUMBER}"
		printf "  %-40s: %s\n" "RECIPE_RIGHTS" "${RECIPE_RIGHTS}"
		printf "  %-40s: %s\n" "RECIPE_NAME" "${RECIPE_NAME}"
		printf "  %-40s: %s\n" "RECIPE_DISPLAY_NAME" "${RECIPE_DISPLAY_NAME}"
		printf "  %-40s: %s\n" "RECIPE_SCRIPT_FILE_PATH" "${RECIPE_SCRIPT_FILE_PATH}"
		printf "\n"
	done
}

function re_index_recipes(){
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
		RECIPE_NEW_ID="${CURRENT_RECIPE_NUMBER}-${RECIPE_RIGHTS}-${RECIPE_NAME}"
		
		if [[ "${RECIPE_ID}" = "${RECIPE_NEW_ID}" ]]; then
			printf "  => no changes\n\n"
		else
			printf "  => renamed with RECIPE_ID[%s]\n\n" "${RECIPE_NEW_ID}"
			mv "${RECIPES_PARENT_DIRECTORY}/${RECIPE_ID}" "${RECIPES_PARENT_DIRECTORY}/${RECIPE_NEW_ID}"
		fi
	done
}

function fill_recipe_directories_array(){
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

function fill_recipe_array_with_recipe_list_file(){
	if [[ $# -ne 2 ]]; then
		printf "${FUNCNAME[0]}() expects RECIPE_LIST_FILE and RECIPE_ARRAY_NAME in arguments\n"
		exit 1
	fi
	RECIPE_LIST_FILE="${1}"
	if [[ ! -f "${RECIPE_LIST_FILE}" ]]; then
		printf "Cannot find RECIPE_LIST_FILE[%s]\n" "${RECIPE_LIST_FILE}"
		exit 1
	fi
	
	# Retrieve and fill array of recipes
	RECIPE_ARRAY_NAME="${2}"
	declare -n RECIPE_ARRAY="${RECIPE_ARRAY_NAME}"
	RECIPE_ARRAY=()
	while read LINE; do
		# Remove extra spaces
		LINE=$(echo "${LINE}"|awk '{$1=$1};1')
		
		# Skip lines starting with the character hash '#'
		if [[ "${LINE}" =~ ^#.* ]]; then
			continue
		fi
		
		# Skip empty lines
		if [[ -z "${LINE}" ]]; then
			continue
		fi
		
		# Check recipe directory does exist
		RECIPE_DIRECTORY="${LINE}"
		if [[ ! -d "${RECIPE_DIRECTORY}" ]]; then
			printf "ERROR: cannot find RECIPE_DIRECTORY[%s]\n" "${RECIPE_DIRECTORY}"
			exit 1
		fi
		
		# Check recipe ID is well formed
		RECIPE_ID=$(basename "${RECIPE_DIRECTORY}")
		if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
			printf "ERROR: RECIPE_ID[%s] is not well formed\n" "${RECIPE_ID}"
			exit 1
		fi
		
		RECIPE_ARRAY+=( "${RECIPE_DIRECTORY}" )
	done < "${RECIPE_LIST_FILE}"
}

function retrieve_distribution(){
	LSB_RELEASE_DISTRIBUTOR=$(lsb_release -si)
	LSB_RELEASE_CODENAME=$(lsb_release -sc)
	printf "${LSB_RELEASE_DISTRIBUTOR,,}_${LSB_RELEASE_CODENAME,,}"
}

function select_from_recipe_directories_array(){
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

function initialize_recipe(){
	# Retrieve and source FELIX_CONF_FILE
	if [[ -z "${FELIX_ROOT}" ]]; then
		printf "FELIX_ROOT should not be empty"
		exit 1
	fi
	declare -g FELIX_CONF_FILE="${FELIX_ROOT}/felix.conf"
	if [[ ! -f "${FELIX_CONF_FILE}" ]]; then
		printf "Cannot find FELIX_CONF_FILE[%s]\n" "${FELIX_CONF_FILE}"
		exit 1
	fi
	source "${FELIX_CONF_FILE}"
	
	# Retrieve and declare RECIPE_FAMILY_DIRECTORY
	declare -g RECIPE_FAMILY_DIRECTORY="${FELIX_ROOT}/recipes"
	
	# Check RECIPE_DIRECTORY
	if [[ -z "${RECIPE_DIRECTORY}" ]]; then
		printf "RECIPE_DIRECTORY should not be empty"
		exit 1
	fi
	RECIPE_ID=$(basename ${RECIPE_DIRECTORY})
	if [[ ! "${RECIPE_ID}" =~ ${RECIPE_ID_REGEX} ]]; then
		printf "RECIPE_ID[%s] is not well formed\n" "${RECIPE_ID}"
		exit 1
	fi
	
	# Retrieve and declare RECIPE_LOG_FILE
	RECIPE_SCRIPT_FILE=$(retrieve_recipe_script_file "${RECIPE_ID}")
	declare -g RECIPE_LOG_FILE="$(retrieve_log_file_name ${RECIPE_SCRIPT_FILE}|xargs readlink -f)"
	
	# Print recipe information
	RECIPE_ID=$(basename "${RECIPE_DIRECTORY}")
	printf "%-30s: %s\n" "FELIX_ROOT" "${FELIX_ROOT}"
	printf "%-30s: %s\n" "FELIX_CONF_FILE" "${FELIX_CONF_FILE}"
	printf "%-30s: %s\n" "RECIPE_FAMILY_DIRECTORY" "${RECIPE_FAMILY_DIRECTORY}"
	printf "%-30s: %s\n" "RECIPE_DIRECTORY" "${RECIPE_DIRECTORY}"
	printf "%-30s: %s\n" "RECIPE_SCRIPT_FILE" "${RECIPE_DIRECTORY}/${RECIPE_SCRIPT_FILE}"
	printf "%-30s: %s\n" "RECIPE_LOG_FILE" "${RECIPE_LOG_FILE}"
	printf "\n"
}

function retrieve_log_file_name(){
	if [[ $# -ne 1 ]]; then
		printf "${FUNCNAME[0]}() expects FILE_NAME in argument\n"
		exit 1
	fi
	FILE_NAME="${1}"
	LOG_FILE_NAME="${FILE_NAME}.log.$(date -u +'%y%m%d-%H%M%S')"
	echo "${LOG_FILE_NAME}"
}

function list_log_files(){
	find . -iname "*.log.*" -type f
}

function delete_log_files(){
	find . -name "*.log.*" -type f -exec rm -fr {} \;
}

function create_recipe_list_file_from_directory(){
	if [[ $# -ne 2 ]]; then
		printf "${FUNCNAME[0]}() expects SOURCE_DIRECTORY and RECIPE_LIST_FILE in argument\n"
		exit 1
	fi
	SOURCE_DIRECTORY="${1}"
	if [[ ! -d "${SOURCE_DIRECTORY}" ]]; then
		printf "ERROR: cannot find SOURCE_DIRECTORY[${SOURCE_DIRECTORY}]\n"
		exit 1
	fi
	FELIX_ROOT=$(dirname ${BASH_SOURCE})
	SOURCE_DIRECTORY_RELATIVE_TO_FELIX_ROOT=$(realpath --relative-to="${FELIX_ROOT}" "${SOURCE_DIRECTORY}")
	RECIPE_LIST_FILE="${2}"
	printf "\n\n" >> "${RECIPE_LIST_FILE}"
	printf "%80s" | tr " " "#" >> "${RECIPE_LIST_FILE}"
	printf "\n# Recipes from ${SOURCE_DIRECTORY_RELATIVE_TO_FELIX_ROOT}\n" >> "${RECIPE_LIST_FILE}"
	printf "%80s" | tr " " "#" >> "${RECIPE_LIST_FILE}"
	printf "\n" >> "${RECIPE_LIST_FILE}"
	for FILE in "${SOURCE_DIRECTORY_RELATIVE_TO_FELIX_ROOT}"/*; do
		if [[ ! -d "${FILE}" ]]; then
			continue;
		fi
		DIRECTORY_NAME=$(basename "${FILE}")
		if [[ ! "${DIRECTORY_NAME}" =~ ${RECIPE_ID_REGEX} ]]; then
			continue
		fi
		RECIPE_DIRECTORY_RELATIVE_TO_FELIX_ROOT=$(realpath --relative-to="${FELIX_ROOT}" "${FILE}")
		printf "${RECIPE_DIRECTORY_RELATIVE_TO_FELIX_ROOT}\n" >> "${RECIPE_LIST_FILE}"
	done
}
