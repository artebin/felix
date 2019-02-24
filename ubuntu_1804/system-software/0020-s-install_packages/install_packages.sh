#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

process_package_install_list(){
	echo "Install packages ..."
	
	# Check that dpkg is not locked
	DPKG_LOCK=$(fuser /var/lib/dpkg/lock 2>/dev/null)
	if [[ ! -z "${DPKG_LOCK}" ]]; then
		printf "Dpkg seems to be locked but it should not be during the execution of this script\n" 1>&2
		exit 1
	fi
	
	# Synchronized package index files from sources
	apt-get update
	
	PACKAGES_LIST_FILE="${RECIPE_DIR}/packages.install.minimal.list"
	
	# Build the apt input from PACKAGES_LIST_FILE, one package per line
	APT_INPUT_FILE="${RECIPE_DIR}/apt.pkg.list"
	if [[ -f "${APT_INPUT_FILE}" ]]; then
		rm -f "${APT_INPUT_FILE}"
	fi
	while read LINE; do
		INDEX_OF_COMMENT=`expr index "${LINE}" '#'`
		if [[ "${INDEX_OF_COMMENT}" -eq 0 ]]; then
			PACKAGES_LINE=${LINE}
		else
			SUBSTRING_LENGTH=`expr ${INDEX_OF_COMMENT}-1`
			PACKAGES_LINE=${LINE:0:${SUBSTRING_LENGTH}}
		fi
		PACKAGES_LINE=$(echo "${PACKAGES_LINE}"|awk '{$1=$1};1')
		if [[ ! -z "${PACKAGES_LINE}" ]]; then
			echo "${PACKAGES_LINE}" | tr " " "\n" >>"${APT_INPUT_FILE}"
		fi
	done <"${PACKAGES_LIST_FILE}"
	
	# Check package availability
	PACKAGE_MISSING_LIST_FILE="${RECIPE_DIR}/packages.missing.list"
	if [[ -f "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		rm -f "${PACKAGE_MISSING_LIST_FILE}"
	fi
	while read PACKAGE_NAME; do
		if [[ -z "${PACKAGE_NAME}" ]]; then
			continue;
		fi
		if is_package_available "${PACKAGE_NAME}"; then
			PACKAGE_DESCRIPTION=$(retrieve_package_short_description "${PACKAGE_NAME}")
			if is_package_installed "${PACKAGE_NAME}"; then
				printf "[\e[92m%s\e[0m] [\e[92m%s\e[0m] %s\n" "AVAILABLE" "INSTALLED    " "${PACKAGE_NAME}: ${PACKAGE_DESCRIPTION}"
			else
				printf "[\e[92m%s\e[0m] [%s] %s\n"            "AVAILABLE" "NOT INSTALLED" "${PACKAGE_NAME}: ${PACKAGE_DESCRIPTION}"
			fi
		else
			printf     "[\e[91m%s\e[0m] [%s] %s\n"            "MISSING  " "             " "${PACKAGE_NAME}"
			echo "${PACKAGE_NAME}" >>"${PACKAGE_MISSING_LIST_FILE}"
		fi
	done <"${APT_INPUT_FILE}"
	if [[ -s "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		echo "Some packages are missing"
		echo "See ${PACKAGE_MISSING_LIST_FILE}"
		exit 1
	fi
	
	# Proceed install
	xargs apt-get -y install <"${APT_INPUT_FILE}"
	
	# Cleaning
	rm -f "${APT_INPUT_FILE}"
	
	echo
}

process_package_install_list 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
