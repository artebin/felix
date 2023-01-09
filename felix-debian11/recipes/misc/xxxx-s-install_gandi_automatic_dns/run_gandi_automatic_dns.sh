#!/usr/bin/env bash

GANDI_DNS_CONFIGURATION_FILE=""
PUBLIC_IP=""
GANDI_API_KEY=""
GANDI_DOMAIN_NAME=""
GANDI_RECORD_LIST=""

print_usage(){
	printf "Usage: ${0} -c <GANDI_DNS_CONFIGURATION_FILE>\n\n"
}

retrieve_gandi_dns_configuration(){
	GANDI_API_KEY=$(crudini --get "${GANDI_DNS_CONFIGURATION_FILE}" '' "GANDI_API_KEY")
	GANDI_DOMAIN_NAME=$(crudini --get "${GANDI_DNS_CONFIGURATION_FILE}" '' "GANDI_DOMAIN_NAME")
	GANDI_RECORD_LIST=$(crudini --get "${GANDI_DNS_CONFIGURATION_FILE}" '' "GANDI_RECORD_LIST")
}

retrieve_public_ip(){
	PUBLIC_IP=$(curl -s ipinfo.io/ip)
}

run_gandi_automatic_dns(){
	echo "${PUBLIC_IP}" | bash gad -5 -s -a "${GANDI_API_KEY}" -d "${GANDI_DOMAIN_NAME}" -r "${GANDI_RECORD_LIST}"
}

while getopts "c:" ARG; do
	case "${ARG}" in
		c)
			GANDI_DNS_CONFIGURATION_FILE="${OPTARG}"
			;;
		*)
			printf "Unknown option: %s\n" "${OPTARG}" 1>&2
			print_usage
			exit 1
			;;
	esac
done

# Load configuration file
if [[ ! -f "${GANDI_DNS_CONFIGURATION_FILE}" ]]; then
	printf "Cannot find GANDI_DNS_CONFIGURATION_FILE[%s]\n" "${GANDI_LIVE_DNS_CONFIGURATION_FILE}"
	print_usage
	exit 1
fi
retrieve_gandi_dns_configuration

# Check configuration
if [[ -z "${GANDI_API_KEY}" ]]; then
	printf "Cannot read GANDI_API_KEY[%s] in GANDI_DNS_CONFIGURATION_FILE[%s]\n" "${GANDI_API_KEY}" "${GANDI_DNS_CONFIGURATION_FILE}"
	exit 1
fi
if [[ -z "${GANDI_DOMAIN_NAME}" ]]; then
	printf "Cannot read GANDI_DOMAIN_NAME[%s] in GANDI_DNS_CONFIGURATION_FILE[%s]\n" "${GANDI_DOMAIN_NAME}" "${GANDI_DNS_CONFIGURATION_FILE}"
	exit 1
fi
if [[ -z "${GANDI_RECORD_LIST}" ]]; then
	printf "Cannot read GANDI_RECORD_LIST[%s] in GANDI_DNS_CONFIGURATION_FILE[%s]\n" "${GANDI_RECORD_LIST}" "${GANDI_DNS_CONFIGURATION_FILE}"
	exit 1
fi

# Retrieve public IP
retrieve_public_ip

# Console traces
printf "%-20s: %s\n" "PUBLIC_IP" "${PUBLIC_IP}"
printf "%-20s: %s\n" "GANDI_DOMAIN_NAME" "${GANDI_DOMAIN_NAME}"
printf "%-20s: %s\n" "GANDI_RECORD_LIST" "${GANDI_RECORD_LIST}"

# Run gandi_automatic_dns
run_gandi_automatic_dns
