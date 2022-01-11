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

# Configuration file GANDI_DNS_CONFIGURATION_FILE is a properties file containing the 3 properties:
# GANDI_API_KEY
# GANDI_DOMAIN_NAME
# GANDI_RECORD_LIST
GANDI_DNS_CONFIGURATION_FILE="config"
GANDI_AUTOMATIC_DNS_RUN_PERIOD="*/30 * * * *"

install_gandi_automatic_dns(){
	printf "Installing gandi_automatic_dns (gad) ...\n"
	
	# Clone git repository <https://github.com/brianpcurran/gandi-automatic-dns>
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/brianpcurran/gandi-automatic-dns
	
	# Install
	GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY="/opt/gandi_automatic_dns"
	if [[ ! -d "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}" ]]; then
		mkdir "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}"
	fi
	cd "${RECIPE_DIRECTORY}"
	cp gandi-automatic-dns/gad "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}"
	
	# Add run script and configuration file
	cd "${RECIPE_DIRECTORY}"
	cp run_gandi_automatic_dns.sh "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}"
	if [[ ! -f "${GANDI_DNS_CONFIGURATION_FILE}" ]]; then
		printf "Cannot find GANDI_DNS_CONFIGURATION_FILE[%s]\n" "${GANDI_DNS_CONFIGURATION_FILE}"
		printf "Please edit %s and set variable GANDI_DNS_CONFIGURATION_FILE\n" "${BASH_SOURCE}"
		exit 1
	fi
	cp "${GANDI_DNS_CONFIGURATION_FILE}" "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}"
	chmod 600 "${GANDI_AUTOMATIC_DNS_INSTALL_DIRECTORY}/${GANDI_DNS_CONFIGURATION_FILE}"
	
	# Configure logrotate
	GANDI_AUTOMATIC_DNS_LOG_DIRECTORY="/var/log/gandi_automatic_dns"
	if [[ ! -d "${GANDI_AUTOMATIC_DNS_LOG_DIRECTORY}" ]]; then
		mkdir "${GANDI_AUTOMATIC_DNS_LOG_DIRECTORY}"
	fi
	cd "${RECIPE_DIRECTORY}"
	cp logrotate.gandi_automatic_dns /etc/logrotate.d
	
	# Schedule in crontab
	printf "%s cd /opt/gandi_automatic_dns;bash run_gandi_automatic_dns.sh -c config >>/var/log/gandi_automatic_dns/gandi_automatic_dns.log 2>&1\n" "${GANDI_AUTOMATIC_DNS_RUN_PERIOD}" > cron_task
	crontab -u root cron_task
	
	# Cleaning
	rm -fr gandi-automatic-dns
	rm -f cron_task
	
	printf "\n"
}

install_gandi_automatic_dns 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
