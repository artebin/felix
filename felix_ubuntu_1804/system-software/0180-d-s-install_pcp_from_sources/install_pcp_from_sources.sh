#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pcp_from_sources(){
	echo "Installing pcp from sources ..."
	
	echo "Installing dependencies ..."
	apt-get build-dep pcp
	
	echo "Cloning git repository <https://github.com/performancecopilot/pcp> ..."
	cd "${RECIPE_DIR}"
	git clone https://github.com/performancecopilot/pcp
	
	echo "Compiling and installing ..."
	cd "${RECIPE_DIR}"
	cd pcp
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-webapi 
	make
	groupadd -r pcp
	useradd -c "Performance Co-Pilot" -g pcp -d /var/lib/pcp -M -r -s /usr/sbin/nologin pcp
	make install
	
	echo "Starting pmcd service ..."
	service pmcd start
	
	echo "Cleaning ..."
	cd "${RECIPE_DIR}"
	rm -fr pcp
	
	echo
}

install_pcp_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
