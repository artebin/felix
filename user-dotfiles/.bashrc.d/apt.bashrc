#!/usr/bin/env bash

function package_reinstall_and_revert_conf_files(){
	apt-get install --reinstall -o Dpkg::Options::="--force-confask,confnew,confmiss" "${@}"
}
alias package_reinstall_and_revert_conf_files=package_reinstall_and_revert_conf_files
