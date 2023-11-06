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

install_telegraf_influxdb(){
	printf "Installing telegraf and influxdb ...\n"
	
	# See <https://kifarunix.com/install-and-setup-tig-stack-on-ubuntu-20-04>
	
	# Install telegraf
	wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
	source /etc/lsb-release
	echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
	apt-get update
	apt-get install telegraf
	
	# Start telegraf
	systemctl enable --now telegraf
	systemctl status telegraf
	
	# Install influxdb
	wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.0_amd64.deb
	dpkg -i influxdb_1.8.0_amd64.deb
	
	# Start influxdb
	systemctl enable --now influxdb
	systemctl status influxdb
	
	printf "\n"
}

install_telegraf_influxdb 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
