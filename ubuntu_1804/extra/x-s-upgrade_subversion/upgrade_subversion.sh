#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

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

upgrade_subversion 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
