#!/usr/bin/env bash

function svn_mark_missing_as_deletions(){
	if [[ ! -z "$(svn st | grep ^! | awk '{print " --force "$2}')" ]]; then
		svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm
	fi
}
alias svn_mark_missing_as_deletions=svn_mark_missing_as_deletions

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
