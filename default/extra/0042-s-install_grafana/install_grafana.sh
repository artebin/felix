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

install_grafana(){
	printf "Installing grafana ...\n"
	
	# See <https://kifarunix.com/install-and-setup-tig-stack-on-ubuntu-20-04>
	
	# Install grafana
	apt-get install -y adduser libfontconfig1
	wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
	add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
	apt update -y
	apt-get install -y grafana
	
	# Start grafana server
	systemctl daemon-reload
	systemctl enable --now grafana-server
	systemctl status grafana-server
	
	printf "\n"
}

install_grafana 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
