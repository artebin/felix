#!/usr/bin/env bash

print_usage(){
	printf "Usage: ${0} TIMEOUT_IN_MINUTES\n\n"
}

# Default timeout is 15 minutes
DEFAULT_TIMEOUT_IN_MILLIS=$(( 15 * 60 * 1000 ))
TIMEOUT_IN_MILLIS="${DEFAULT_TIMEOUT_IN_MILLIS}"

if [[ ! $(type xprintidle 2>/dev/null) ]]; then
	printf "xprintidle is required for ${0} to run\n\n"
	print_usage
	exit 1
fi

if [[ ! $(type xtrlock 2>/dev/null) ]]; then
	printf "xtrlock is required for ${0} to run\n\n"
	print_usage
	exit 1
fi

if [[ "${#}" -eq 1 ]]; then
	TIMEOUT_IN_MILLIS=$(( "${1}" * 60 * 1000 ))
fi

while :; do
	IDLE_IN_MILLIS=$(xprintidle)
	if [[ "${IDLE_IN_MILLIS}" -gt  "${TIMEOUT_IN_MILLIS}" ]]; then
		[[ $(ps h -C xtrlock) ]] || xtrlock
	fi
	printf "IDLE_IN_MILLIS: %s\n" "${IDLE_IN_MILLIS}"
	printf "TIMEOUT_IN_MILLIS: %s\n" "${TIMEOUT_IN_MILLIS}"
	printf "\n"
	sleep 10
done
