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
	
	# Generate APT_PACKAGE_LIST_FILE from PACKAGE_LIST_FILE
	# It will also fill PACKAGE_MISSING_LIST_FILE
	PACKAGE_LIST_FILE="${RECIPE_DIR}/packages.install.minimal.list"
	APT_PACKAGE_LIST_FILE="${RECIPE_DIR}/apt.list"
	if [[ -f "${APT_PACKAGE_LIST_FILE}" ]]; then
		rm -f "${APT_PACKAGE_LIST_FILE}"
	fi
	PACKAGE_MISSING_LIST_FILE="${RECIPE_DIR}/packages.missing.list"
	if [[ -f "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		rm -f "${PACKAGE_MISSING_LIST_FILE}"
	fi
	generate_apt_package_list_file "${PACKAGE_LIST_FILE}" "${APT_PACKAGE_LIST_FILE}" "${PACKAGE_MISSING_LIST_FILE}"
	
	# Exit if some packages are missing
	if [[ -f "${PACKAGE_MISSING_LIST_FILE}" && ! -s "${PACKAGE_MISSING_LIST_FILE}" ]]; then
		printf "Some packages are missing\n"
		printf "See PACKAGE_MISSING_LIST_FILE: ${PACKAGE_MISSING_LIST_FILE}\n"
		exit 1
	fi
	
	# Proceed install
	xargs apt-get -o Dpkg::Options::=--force-confnew -y install <"${APT_PACKAGE_LIST_FILE}"
	
	# Cleaning
	rm -f "${APT_PACKAGE_LIST_FILE}"
	
	echo
}

process_package_install_list 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
