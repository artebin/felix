#!/usr/bin/env bash

function print_usage(){
	cat << EOF
Usage: ./rififi.sh -f <CONFIGURATION_FILE> [-hdn] [SELECTED_ROFI_MENU_ENTRY]

Where:
  -f      path to CONFIGURATION_FILE
  -h      help
  -d      dry run
  -n      do not show symbols

Example:
  rofi -show powermenu -modi powermenu:"./rififi.sh -f ./rififi-power-menu.conf"
EOF
}

CONFIGURATION_FILE=""
DRY_RUN="false"
SHOW_SYMBOLS="true"

while getopts "f:hdn" OPT; do
	case "${OPT}" in
		f)
			CONFIGURATION_FILE="${OPTARG}"
			;;
		h)
			print_usage
			exit 0
			;;
		d)
			DRY_RUN="true"
			;;
		n)
			SHOW_SYMBOLS="false"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))
SELECTED_ROFI_MENU_ENTRY=""
if [[ $# -gt 0 ]]; then
	SELECTED_ROFI_MENU_ENTRY="${@}"
fi

###########################
# Load configuration file
###########################
MENU_TITLE=""
declare -a MENU_ITEM_ID_ALL_ARRAY
declare -A MENU_ITEM_VISIBLE_ARRAY
declare -A MENU_ITEM_REQUEST_CONFIRMATION_ARRAY
declare -A MENU_ITEM_SYMBOL_ARRAY
declare -A MENU_ITEM_TEXT_ARRAY
declare -A MENU_ITEM_ACTION_ARRAY

MENU_ITEM_SYMBOL_ARRAY[cancel]=""

if [[ ! -f "${CONFIGURATION_FILE}" ]]; then
	printf "Cannot find CONFIGURATION_FILE[%s]\n" >&2
	exit 1
fi
source "${CONFIGURATION_FILE}"

#################################################################
# Build ROFI_MENU_CHOICE_ARRAY and ROFI_MENU_CONFIRMATION_ARRAY
#################################################################

# Function below is used for choices and confirmations
function set_rofi_menu_entry(){
	ICON="<span font_size=\"medium\">${1}</span>"
	TEXT="<span font_size=\"medium\">${2}</span>"
	if [[ "${SHOW_SYMBOLS}" == "true" ]]; then
		echo -e "\u200e${ICON} \u2068${TEXT}\u2069"
	else
		echo -e "${TEXT}"
	fi
}

declare -A ROFI_MENU_CHOICE_ARRAY
for MENU_ITEM_ID in "${MENU_ITEM_ID_ALL_ARRAY[@]}"; do
	MENU_ITEM_SYMBOL="${MENU_ITEM_SYMBOL_ARRAY[${MENU_ITEM_ID}]}"
	MENU_ITEM_TEXT="${MENU_ITEM_TEXT_ARRAY[${MENU_ITEM_ID}]}"
	ROFI_MENU_CHOICE_ARRAY[${MENU_ITEM_ID}]="$(set_rofi_menu_entry "${MENU_ITEM_SYMBOL}" "${MENU_ITEM_TEXT}")"
done

declare -A ROFI_MENU_CONFIRMATION_ARRAY
for MENU_ITEM_ID in "${MENU_ITEM_ID_ALL_ARRAY[@]}"; do
	MENU_ITEM_SYMBOL="${MENU_ITEM_SYMBOL_ARRAY[${MENU_ITEM_ID}]}"
	MENU_ITEM_TEXT="${MENU_ITEM_TEXT_ARRAY[${MENU_ITEM_ID}]}"
	ROFI_MENU_CONFIRMATION_ARRAY[${MENU_ITEM_ID}]=$(set_rofi_menu_entry "${MENU_ITEM_SYMBOL}" "Yes, ${MENU_ITEM_TEXT}")
done
ROFI_MENU_CONFIRMATION_ARRAY[cancel]=$(set_rofi_menu_entry "${MENU_ITEM_SYMBOL_ARRAY[cancel]}" "No, cancel")

##########################################################################################
# Retrieve SELECTED_MENU_ITEM_ID or CONFIRMED_MENU_ITEM_ID from SELECTED_ROFI_MENU_ENTRY
##########################################################################################
SELECTED_MENU_ITEM_ID=""
CONFIRMED_MENU_ITEM_ID=""
if [[ ! -z "${SELECTED_ROFI_MENU_ENTRY}" ]]; then
	for MENU_ITEM_ID in "${!ROFI_MENU_CHOICE_ARRAY[@]}"; do
		ROFI_MENU_CHOICE="${ROFI_MENU_CHOICE_ARRAY[${MENU_ITEM_ID}]}"
		if [[ "${ROFI_MENU_CHOICE}" == "${SELECTED_ROFI_MENU_ENTRY}" ]]; then
			SELECTED_MENU_ITEM_ID="${MENU_ITEM_ID}"
			break
		fi
	done
	for MENU_ITEM_ID in "${!ROFI_MENU_CONFIRMATION_ARRAY[@]}"; do
		ROFI_MENU_CONFIRMATION="${ROFI_MENU_CONFIRMATION_ARRAY[${MENU_ITEM_ID}]}"
		if [[ "${ROFI_MENU_CONFIRMATION}" == "${SELECTED_ROFI_MENU_ENTRY}" ]]; then
			CONFIRMED_MENU_ITEM_ID="${MENU_ITEM_ID}"
			break
		fi
	done
	if [[ -z "${SELECTED_MENU_ITEM_ID}" && -z "${CONFIRMED_MENU_ITEM_ID}" ]]; then
		printf "Cannot find SELECTED_MENU_ITEM_ID or CONFIRMED_MENU_ITEM_ID for SELECTED_ROFI_MENU_ENTRY[%s]\n" "${SELECTED_ROFI_MENU_ENTRY}" >&2
		exit 1
	fi
fi
printf "SELECTED_MENU_ITEM_ID[%s] CONFIRMED_MENU_ITEM_ID[%s]\n" "${SELECTED_MENU_ITEM_ID}" "${CONFIRMED_MENU_ITEM_ID}" >&2

# Rofi configuration: do not allow custom entries
echo -e "\0no-custom\x1ftrue"

# Rofi configuration: use markup
echo -e "\0markup-rows\x1ftrue"

##############################################################################
# Print rofi menu or execute SELECTED_MENU_ITEM_ID or CONFIRMED_MENU_ITEM_ID
##############################################################################

function execute_action_for_menu_item_id(){
	MENU_ITEM_ID="${1}"
	if [[ -z "${MENU_ITEM_ID}" ]]; then
		printf "MENU_ITEM_ID should not be empty\n" >&2
		exit 1
	fi
	MENU_ITEM_ACTION="${MENU_ITEM_ACTION_ARRAY[${MENU_ITEM_ID}]}"
	if ${DRY_RUN}; then
		printf "Executing MENU_ITEM_ID[%s] MENU_ITEM_ACTION[%s] DRY_RUN[%s]\n" "${MENU_ITEM_ID}" "${MENU_ITEM_ACTION}" "${DRY_RUN}" >&2
	else
		printf "Executing MENU_ITEM_ID[%s] MENU_ITEM_ACTION[%s] DRY_RUN[%s]\n" "${MENU_ITEM_ID}" "${MENU_ITEM_ACTION}" "${DRY_RUN}" >&2
		eval "${MENU_ITEM_ACTION_ARRAY[${MENU_ITEM_ID}]}"
	fi
}

if [[ ! -z "${CONFIRMED_MENU_ITEM_ID}" ]]; then
	execute_action_for_menu_item_id "${CONFIRMED_MENU_ITEM_ID}"
elif [[ ! -z "${SELECTED_MENU_ITEM_ID}" ]]; then
	MENU_ITEM_REQUEST_CONFIRMATION="${MENU_ITEM_REQUEST_CONFIRMATION_ARRAY[${SELECTED_MENU_ITEM_ID}]}"
	printf "SELECTED_MENU_ITEM_ID[%s] MENU_ITEM_REQUEST_CONFIRMATION[%s]\n" "${SELECTED_MENU_ITEM_ID}" "${MENU_ITEM_REQUEST_CONFIRMATION}" >&2
	if ${MENU_ITEM_REQUEST_CONFIRMATION}; then
		echo -e "\0prompt\x1fAre you sure"
		echo -e "${ROFI_MENU_CONFIRMATION_ARRAY[${SELECTED_MENU_ITEM_ID}]}\0icon\x1f${MENU_ITEM_SYMBOL_ARRAY[${SELECTED_MENU_ITEM_ID}]}"
		echo -e "${ROFI_MENU_CONFIRMATION_ARRAY[cancel]}\0icon\x1f${MENU_ITEM_SYMBOL_ARRAY[cancel]}"
	else
		execute_action_for_menu_item_id "${SELECTED_MENU_ITEM_ID}"
	fi
else
	echo -e "\0prompt\x1f${MENU_TITLE}"
	for MENU_ITEM_ID in "${!MENU_ITEM_VISIBLE_ARRAY[@]}"; do
		MENU_ITEM_ENTRY="${ROFI_MENU_CHOICE_ARRAY[${MENU_ITEM_ID}]}"
		MENU_ITEM_SYMBOL="${MENU_ITEM_SYMBOL_ARRAY[${MENU_ITEM_ID}]}"
		echo -e "${MENU_ITEM_ENTRY}\0icon\x1f${MENU_ITEM_SYMBOL}"
	done
fi
