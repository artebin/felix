#!/usr/bin/env bash

XPROP_KEY_VALUE_REGEX="([_A-Z]+) = (.+)"
XPROP_CURRENT_DESKTOP=$(xprop -root -notype _NET_CURRENT_DESKTOP)
if [[ ! "${XPROP_CURRENT_DESKTOP}" =~ ${XPROP_KEY_VALUE_REGEX} ]]; then
	echo "XPROP_CURRENT_DESKTOP is not well formed: ${XPROP_CURRENT_DESKTOP}"
	exit 1
fi
CURRENT_DESKTOP_ID=${BASH_REMATCH[2]}
echo "CURRENT_DESKTOP_ID=${CURRENT_DESKTOP_ID}"

# can user `xdotool get_desktop`

IFS=$'\n'
readarray -t WINDOW_INFO_ARRAY < <(wmctrl -l)
WINDOW_INFO_REGEX="([^ ]+)( +)([^ ]+)( +)(.*)"
WINDOW_ID_FOR_CURRENT_DESKTOP_ARRAY=()
for WINDOW_INFO in ${WINDOW_INFO_ARRAY[@]}; do
	if [[ ! "${WINDOW_INFO}" =~ ${WINDOW_INFO_REGEX} ]]; then
		echo "WINDOW_INFO is not well formed: ${WINDOW_INFO}"
	fi
	WINDOW_ID=${BASH_REMATCH[1]}
	WINDOW_WORKSPACE_ID=${BASH_REMATCH[3]}
	#echo "WINDOW_WORKSPACE_ID=${WINDOW_WORKSPACE_ID}"
	#echo "CURRENT_DESKTOP_ID=${CURRENT_DESKTOP_ID}"
	#echo
	if [ "${WINDOW_WORKSPACE_ID}" = "${CURRENT_DESKTOP_ID}" ]; then
		WINDOW_ID_FOR_CURRENT_DESKTOP_ARRAY+=( "${WINDOW_ID}" )
	fi
done

echo "WINDOW_ID_FOR_CURRENT_DESKTOP_ARRAY=${WINDOW_ID_FOR_CURRENT_DESKTOP_ARRAY[@]}"

for WINDOw_ID in "${WINDOW_ID_FOR_CURRENT_DESKTOP_ARRAY[@]}"; do
	WINDOW_INFO=$(xwininfo -id "${WINDOw_ID}")
	#WINDOW_INFO=$(xprop -id "${WINDOw_ID}")
	echo "${WINDOW_INFO}"
	echo
done

# Can use <https://unix.stackexchange.com/questions/281168/x-find-out-if-a-window-is-visible-to-the-user-i-e-not-covered-by-others>
# Window should be IsViewable

function stacking_window_list(){
	NET_CLIENT_LIST_STACKING_PREFIX_TO_SKIP="_NET_CLIENT_LIST_STACKING(WINDOW): window id # "
	NET_CLIENT_LIST_STACKING_PREFIX_TO_SKIP_LENGTH="${#NET_CLIENT_LIST_STACKING_PREFIX_TO_SKIP}"  
	TMP=$(xprop -root | grep '_NET_CLIENT_LIST_STACKING(WINDOW)')
	TMP=${TMP:NET_CLIENT_LIST_STACKING_PREFIX_TO_SKIP_LENGTH}
	IFS=', ' read -r -a WINDOW_ID_ARRAY <<< "${TMP}"
	
	for WINDOW_ID in ${WINDOW_ID_ARRAY[@]}; do
		echo "WINDOW_ID=${WINDOW_ID}"
	done
}


