#!/usr/bin/env bash

function svn_mark_missing_as_deletions(){
	if [[ ! -z "$(svn st | grep ^! | awk '{print " --force "$2}')" ]]; then
		svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm
	fi
}
alias svn_mark_missing_as_deletions=svn_mark_missing_as_deletions

function git_config_user_name_email(){
	if [[ "${#}" -ne 2 ]]; then
		printf "Usage: %s NAME EMAIL\n" "${FUNCNAME[0]}"
		return
	fi
	NAME="${1}"
	EMAIL="${2}"
	if [[ -z "${NAME}" ]] || [[ -z "${EMAIL}" ]]; then
		printf "Usage: %s NAME EMAIL\n" "${FUNCNAME[0]}"
		return
	fi
	git config user.name "${NAME}"
	git config user.email "${EMAIL}"
}
alias git_config_user_name_email=git_config_user_name_email

function github_clone(){
	if [[ "${#}" -ne 3 ]]; then
		printf "Usage: %s PROTOCOL USER_NAME REPOSITY_NAME\n" "${FUNCNAME[0]}"
		return
	fi
	PROTOCOL="${1}"
	PROTOCOL_HTTPS="https"
	PROTOCOL_SSH="ssh"
	if [[ "${PROTOCOL}" != "${PROTOCOL_HTTPS}" ]] && [[ "${PROTOCOL}" != "${PROTOCOL_SSH}" ]]; then
		printf "Usage: %s PROTOCOL USER_NAME REPOSITY_NAME\n" "${FUNCNAME[0]}"
		return
	fi
	USER_NAME="${2}"
	REPOSITORY_NAME="${3}"
	if [[ "${PROTOCOL}" == "${PROTOCOL_HTTPS}" ]]; then
		git clone "https://github.com/${USER_NAME}/${REPOSITORY_NAME}"
	else
		git clone "ssh://git@github.com/${USER_NAME}/${REPOSITORY_NAME}.git"
	fi
}
alias github_clone=github_clone

alias git_fs="git fetch && git status"

function git_branch_commit_history(){
	if [[ "${#}" -ne 1 ]]; then
		printf "Usage: %s BRANCH\n" "${FUNCNAME[0]}"
		return
	fi
	BRANCH="${1}"
	if [[ -z "${BRANCH}" ]]; then
		printf "Usage: %s BRANCH\n" "${FUNCNAME[0]}"
		return
	fi
	git log "${1}" --not $(git for-each-ref --format='%(refname)' refs/heads/ | grep -v "refs/heads/${1}")
}

alias git_revert_last_commit="git reset --soft HEAD~1"
