#!/usr/bin/env bash

function trace_fail(){
	if [[ $# -lt 1 ]]; then return; fi
	FAIL_MESSAGE="${1}"
	printf "[ERROR] ${1}\n" "${@:2}" 2>&1
}
function trace_info(){
	if [[ $# -lt 1 ]]; then return; fi
	INFO_MESSAGE="${1}"
	printf "[INFO ] ${1}\n" "${@:2}"
}
function trace_debug(){
	if [[ $# -lt 1 ]]; then return; fi
	DEBUG_MESSAGE="${1}"
	printf "[DEBUG] ${1}\n" "${@:2}"
}

function print_usage(){
	cat << EOF
Usage: tint2-toggle [OPTIONS...]"
  -r restart tint2\n"
EOF
}

function fix_primary_monitor_in_tint2_conf(){
	PRIMARY_MONITOR_ID="$(bash -c "TERM=vanilla; xrandr | grep -E '\sconnected\s' | grep -En '\sprimary\s' | cut -d: -f1")"
	if [[ "${?}" != 0 ]]; then
		trace_fail "Cannot retrieve primary monitor with xrandr"
	else
		sed -i "s/systray_monitor.*=.*/systray_monitor=${PRIMARY_MONITOR_ID}/g" "${HOME}/.config/tint2/tint2rc"
	fi
}

function toogle_tint2(){
	if $(pgrep tint2 &>/dev/null); then
		pkill tint2
	else
		fix_primary_monitor_in_tint2_conf
		tint2 &
	fi
}

# Retrieve options
RESTART="false"
while getopts ":r" OPT; do
	case "${OPT}" in
		r)
			RESTART="true"
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

if "${RESTART}"; then
	pkill tint2
	fix_primary_monitor_in_tint2_conf
	tint2 &
else
	toogle_tint2
fi
