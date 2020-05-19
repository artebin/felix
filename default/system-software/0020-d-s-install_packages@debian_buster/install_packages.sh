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

process_package_install_list(){
	printf "Install packages ...\n"
	
	# Check that dpkg is not locked
	DPKG_LOCK=$(fuser /var/lib/dpkg/lock 2>/dev/null)
	if [[ ! -z "${DPKG_LOCK}" ]]; then
		printf "Dpkg seems to be locked but it should not be during the execution of this script\n" 1>&2
		exit 1
	fi
	
	# Synchronized package index files from sources
	apt-get update
	
	# Generate APT_PACKAGE_LIST_FILES from PACKAGE_LIST_FILE
	# It will also fill MISSING_PACKAGE_LIST_FILE
	PACKAGE_LIST_FILE="${RECIPE_DIRECTORY}/packages.install.list"
	APT_PACKAGE_LIST_FILE_NAME_PREFIX="apt_package_list"
	MISSING_PACKAGE_LIST_FILE="${RECIPE_DIRECTORY}/packages.missing.list"
	cd "${RECIPE_DIRECTORY}"
	generate_apt_package_list_files "${PACKAGE_LIST_FILE}" "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}" "${MISSING_PACKAGE_LIST_FILE}"
	
	# Exit if some packages are missing
	if [[ -f "${MISSING_PACKAGE_LIST_FILE}" && ! -s "${MISSING_PACKAGE_LIST_FILE}" ]]; then
		printf "Some packages are missing\n"
		printf "See MISSING_PACKAGE_LIST_FILE: ${MISSING_PACKAGE_LIST_FILE}\n"
		rm -f "${APT_PACKAGE_LIST_FILE}"
		exit 1
	fi
	
	# Proceed install with --force-confnew
	# Always install the new version of the configuration file, the current version is kept in a file with the .dpkg-old suffix
	for APT_PACKAGE_FILE_LIST in "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}"*; do
		xargs apt-get -o Dpkg::Options::=--force-confnew -y install <"${APT_PACKAGE_FILE_LIST}"
	done
	
	# Cleaning
	rm -f "${APT_PACKAGE_LIST_FILE}"
	
	printf "\n"
}

process_package_install_list 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
