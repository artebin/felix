#!/usr/bin/env bash

#################################################################################
# Script initially from <https://github.com/jluttine/rofi-power-menu>.
#
# It defines just a mode for rofi instead of being a self-contained
# executable that launches rofi by itself. This makes it more flexible than
# running rofi inside this script as now the user can call rofi as one pleases.
#
# For instance: 
#   rofi -show powermenu -modi powermenu:./rofi-power-menu.sh
#################################################################################

function print_usage(){
	echo "rofi-power-menu - a power menu mode for Rofi"
	echo
	echo "Usage: rofi-power-menu [--choices CHOICES] [--confirm CHOICES]"
	echo "                       [--choose CHOICE] [--dry-run] [--symbols|--no-symbols]"
	echo
	echo "Use with Rofi in script mode. For instance, to ask for shutdown or reboot:"
	echo
	echo "  rofi -show menu -modi \"menu:rofi-power-menu --choices=shutdown/reboot\""
	echo
	echo "Available options:"
	echo "  --dry-run          Don't perform the selected action but print it to stderr."
	echo "  --choices CHOICES  Show only the selected choices in the given order. Use / "
	echo "                     as the separator. Available choices are lockscreen, logout,"
	echo "                     suspend, hibernate, reboot and shutdown. By default, all"
	echo "                     available choices are shown."
	echo "  --confirm CHOICES  Require confirmation for the gives choices only. Use / as"
	echo "                     the separator. Available choices are lockscreen, logout,"
	echo "                     suspend, hibernate, reboot and shutdown. By default, only"
	echo "                     irreversible actions logout, reboot and shutdown require"
	echo "                     confirmation."
	echo "  --choose CHOICE    Preselect the given choice and only ask for a confirmation"
	echo "                     (if confirmation is set to be requested). It is strongly"
	echo "                     recommended to combine this option with --confirm=CHOICE"
	echo "                     if the choice wouldn't require confirmation by default."
	echo "                     Available choices are lockscreen, logout, suspend,"
	echo "                     hibernate, reboot and shutdown."
	echo "  --[no-]symbols     Show Unicode symbols or not. Requires a font with support"
	echo "                     for the symbols. Use, for instance, fonts from the"
	echo "                     Nerdfonts collection. By default, they are shown"
	echo "  -h,--help          Show this help text."
}

# Exit immediately if a command exits with a non-zero status.
set -e

# Treat unset variables as an error when substituting.
set -u

ALL_MENU_ITEM_ARRAY=(shutdown reboot suspend hibernate logout lockscreen)

# Show all menu items by default
MENU_ITEMS_TO_SHOW_ARRAY=("${ALL_MENU_ITEM_ARRAY[@]}")

declare -A MENU_ITEM_TEXT_ARRAY
MENU_ITEM_TEXT_ARRAY[lockscreen]="lock screen"
MENU_ITEM_TEXT_ARRAY[switchuser]="switch user"
MENU_ITEM_TEXT_ARRAY[logout]="log out"
MENU_ITEM_TEXT_ARRAY[suspend]="suspend"
MENU_ITEM_TEXT_ARRAY[hibernate]="hibernate"
MENU_ITEM_TEXT_ARRAY[reboot]="reboot"
MENU_ITEM_TEXT_ARRAY[shutdown]="shutdown"

declare -A MENU_ITEM_ICON_ARRAY
MENU_ITEM_ICON_ARRAY[lockscreen]=""
MENU_ITEM_ICON_ARRAY[switchuser]=""
MENU_ITEM_ICON_ARRAY[logout]=""
MENU_ITEM_ICON_ARRAY[suspend]=""
MENU_ITEM_ICON_ARRAY[hibernate]=""
MENU_ITEM_ICON_ARRAY[reboot]=""
MENU_ITEM_ICON_ARRAY[shutdown]=""
MENU_ITEM_ICON_ARRAY[cancel]=""

declare -A MENU_ITEM_ACTION_ARRAY
MENU_ITEM_ACTION_ARRAY[lockscreen]="dm-tool lock"
MENU_ITEM_ACTION_ARRAY[switchuser]="dm-tool switch-to-greeter"
MENU_ITEM_ACTION_ARRAY[logout]="loginctl terminate-session ${XDG_SESSION_ID-}"
MENU_ITEM_ACTION_ARRAY[suspend]="xset dpms force off;systemctl suspend"
MENU_ITEM_ACTION_ARRAY[hibernate]="xset dpms force off;systemctl hibernate"
MENU_ITEM_ACTION_ARRAY[reboot]="systemctl reboot"
MENU_ITEM_ACTION_ARRAY[shutdown]="systemctl poweroff"

# By default, ask for confirmation for actions that are irreversible
MENU_ITEM_REQUESTING_CONFIGURATION_ARRAY=(reboot shutdown logout)

# By default, no dry run
DRY_RUN="false"
SHOW_ICONS="true"

function check_valid(){
	option="$1"
	shift 1
	for entry in "${@}"; do
		if [ -z "${MENU_ITEM_ACTION_ARRAY[$entry]+x}" ]; then
			echo "Invalid choice in $1: $entry" >&2
			exit 1
		fi
	done
}

# Parse command-line options
parsed=$(getopt --options=h --longoptions=help,dry-run,confirm:,choices:,choose:,symbols,no-symbols --name "$0" -- "$@")
if [[ ${?} -ne 0 ]]; then
    echo 'Terminating...' >&2
    exit 1
fi

eval set -- "$parsed"
unset parsed
while true; do
	case "$1" in
		"-h"|"--help")
			print_usage
			exit 0
			;;
		"--dry-run")
			DRY_RUN=true
			shift 1
			;;
		"--confirm")
			IFS='/' read -ra MENU_ITEM_REQUESTING_CONFIGURATION_ARRAY <<< "$2"
			check_valid "$1" "${MENU_ITEM_REQUESTING_CONFIGURATION_ARRAY[@]}"
			shift 2
			;;
		"--choices")
			IFS='/' read -ra MENU_ITEMS_TO_SHOW_ARRAY <<< "$2"
			check_valid "$1" "${MENU_ITEMS_TO_SHOW_ARRAY[@]}"
			shift 2
			;;
		"--choose")
			# Check that the choice is valid
			check_valid "$1" "$2"
			selectionID="$2"
			shift 2
			;;
		"--symbols")
			SHOW_ICONS=true
			shift 1
			;;
		"--no-symbols")
			SHOW_ICONS=false
			shift 1
			;;
		"--")
			shift
			break
			;;
		*)
			echo "Internal error" >&2
			exit 1
			;;
	esac
done

# Define the messages after parsing the CLI options so that it is possible to
# configure them in the future.

function write_message(){
	ICON="<span font_size=\"medium\">${1}</span>"
	TEXT="<span font_size=\"medium\">${2}</span>"
	if [[ "${SHOW_ICONS}" == "true" ]]; then
		echo -n "\u200e${ICON} \u2068${TEXT}\u2069"
	else
		echo -n "${TEXT}"
	fi
}

function print_selection(){
	echo -e "${1}" | $(read -r -d '' ENTRY; echo "echo ${ENTRY}")
}

declare -A messages
for ENTRY in "${ALL_MENU_ITEM_ARRAY[@]}"; do
	messages[${ENTRY}]=$(write_message "${MENU_ITEM_ICON_ARRAY[$ENTRY]}" "${MENU_ITEM_TEXT_ARRAY[$ENTRY]^}")
done

declare -A confirmationMessages
for ENTRY in "${ALL_MENU_ITEM_ARRAY[@]}"; do
	confirmationMessages[${ENTRY}]=$(write_message "${MENU_ITEM_ICON_ARRAY[$ENTRY]}" "Yes, ${MENU_ITEM_TEXT_ARRAY[$ENTRY]}")
done
confirmationMessages[cancel]=$(write_message "${MENU_ITEM_ICON_ARRAY[cancel]}" "No, cancel")


if [[ ${#} -gt 0 ]]; then
	# If arguments given, use those as the selection
	selection="${@}"
else
	# Otherwise, use the CLI passed choice if given
	if [[ -n "${selectionID+x}" ]]; then
		selection="${messages[$selectionID]}"
	fi
fi

# Don't allow custom entries
echo -e "\0no-custom\x1ftrue"

# Use markup
echo -e "\0markup-rows\x1ftrue"

if [[ -z "${selection+x}" ]]; then
	echo -e "\0prompt\x1fPower menu"
	for entry in "${MENU_ITEMS_TO_SHOW_ARRAY[@]}"; do
		echo -e "${messages[$entry]}\0icon\x1f${MENU_ITEM_ICON_ARRAY[$entry]}"
	done
else
	for entry in "${MENU_ITEMS_TO_SHOW_ARRAY[@]}"; do
		if [[ "$selection" = "$(print_selection "${messages[$entry]}")" ]]; then
			# Check if the selected entry is listed in confirmation requirements
			for confirmation in "${MENU_ITEM_REQUESTING_CONFIGURATION_ARRAY[@]}"; do
				if [[ "$entry" = "$confirmation" ]]; then
					# Ask for confirmation
					echo -e "\0prompt\x1fAre you sure"
					echo -e "${confirmationMessages[$entry]}\0icon\x1f${MENU_ITEM_ICON_ARRAY[$entry]}"
					echo -e "${confirmationMessages[cancel]}\0icon\x1f${MENU_ITEM_ICON_ARRAY[cancel]}"
					exit 0
				fi
			done
			# If not, then no confirmation is required, so mark confirmed
			selection=$(print_selection "${confirmationMessages[$entry]}")
		fi
		
		if [[ "$selection" = "$(print_selection "${confirmationMessages[$entry]}")" ]]; then
			if [[ $DRY_RUN = true ]]; then
				# Tell what would have been done
				echo "Selected: $entry" >&2
			else
				# Perform the action
				${MENU_ITEM_ACTION_ARRAY[$entry]}
			fi
			exit 0
		fi
		
		if [[ "$selection" = "$(print_selection "${confirmationMessages[cancel]}")" ]]; then
			# Do nothing
			exit 0
		fi
	done
	
	# The selection didn't match anything, so raise an error
	echo "Invalid selection: $selection" >&2
	exit 1
fi
