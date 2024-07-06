#!/usr/bin/env bash

function date_in_seconds(){
	date -u +%s
}
alias date_in_seconds=date_in_seconds

function date_in_millis(){
	date -u +%s%N | cut -b1-13
}
alias date_in_millis=date_in_millis

function millis_to_date() {
	DATE_IN_MILLIS="${1}"
	if [[ -z "${DATE_IN_MILLIS}" ]]; then
		printf "Usage: %s DATE_IN_MILLIS\n" "${FUNCNAME[0]}"
		return
	fi
	DATE_IN_SECONDS=$(( "${DATE_IN_MILLIS}" / 1000 ))
	date -u -d @${DATE_IN_SECONDS}
}
alias millis_to_date=millis_to_date

function date_to_seconds(){
	DATE_AS_STRING="${1}"
	if [[ -z "${DATE_AS_STRING}" ]]; then
		printf "Usage: %s DATE_AS_STRING\n" "${FUNCNAME[0]}"
		return
	fi
	date -u -d "${DATE_AS_STRING}" %s
}
alias date_to_seconds=date_to_seconds

function dates_to_duration(){
	LEFT_DATE_AS_STRING="${1}"
	RIGHT_DATE_AS_STRING="${2}"
	if [[ -z "${LEFT_DATE_AS_STRING}" ]] | [[ -z "${RIGHT_DATE_AS_STRING}" ]]; then
		printf "Usage: %s LEFT_DATE_AS_STRING RIGHT_DATE_AS_STRING\n" "${FUNCNAME[0]}"
		return
	fi
	LEFT_DATE_IN_SECONDS=$(date -d "${LEFT_DATE_AS_STRING}" +%s)
	RIGHT_DATE_IN_SECONDS=$(date -d "${RIGHT_DATE_AS_STRING}" +%s)
	DIFF_IN_SECONDS=$(( ${RIGHT_DATE_IN_SECONDS} - ${LEFT_DATE_IN_SECONDS} ))
	DAY_COUNT=$(( ${DIFF_IN_SECONDS} / 86400 ))
	SECONDS_FROM_MIDNIGHT_COUNT=$(( ${DIFF_IN_SECONDS} % 86400  ))
	TIME_OF_DAY=$(date -u -d @"${DIFF_IN_SECONDS}" +"%T")
	printf "%sd %s\n" "${DAY_COUNT}" "${TIME_OF_DAY}"
}
alias dates_to_duration=dates_to_duration
