#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pcp_from_sources(){
	printf "Installing pcp from sources ...\n"
	
	printf "Removing 'pcp' if already installed ...\n"
	remove_with_purge_package_if_installed "pcp"
	
	printf "Installing dependencies ...\n"
	install_package_if_not_installed "build-dep"
	
	printf "Cloning git repository <https://github.com/performancecopilot/pcp> ...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/performancecopilot/pcp
	
	printf "Compiling and installing ...\n"
	cd "${RECIPE_DIRECTORY}"
	cd pcp
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-webapi 
	make
	groupadd -r pcp
	useradd -c "Performance Co-Pilot" -g pcp -d /var/lib/pcp -M -r -s /usr/sbin/nologin pcp
	make install
	
	echo "Starting pmcd service ..."
	service pmcd start
	
	printf "Cleaning ...\n"
	cd "${RECIPE_DIRECTORY}"
	rm -fr pcp
	
	printf "\n"
}

install_pcp_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
