#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

upgrade_subversion(){
	printf "Upgrading to subversion 1.11 ...\n"
	
	# See <http://www.neiland.net/blog/article/upgrade-subversion-on-ubuntu-18-04-beyond-1-9/>
	
	echo "deb http://opensource.wandisco.com/ubuntu `lsb_release -cs` svn111" > /etc/apt/sources.list.d/subversion111.list
	wget -q http://opensource.wandisco.com/wandisco-debian-new.gpg -O- | apt-key add -
	apt-get update
	apt-get install subversion subversion-tools
	
	printf "\n"
}

upgrade_subversion 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
