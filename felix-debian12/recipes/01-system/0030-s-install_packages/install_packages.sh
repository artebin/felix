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

function process_package_install_list(){
	printf "Install packages ...\n"
	
	# Check that dpkg is not locked
	DPKG_LOCK=$(fuser /var/lib/dpkg/lock 2>/dev/null)
	if [[ ! -z "${DPKG_LOCK}" ]]; then
		printf "Dpkg seems to be locked but it should not be during the execution of this script\n" 1>&2
		exit 1
	fi
	
	# Synchronized package index files from sources
	apt-get update
	APT_GET_UPDATE_EXIT_CODE="${?}"
	if [[ "${APT_GET_UPDATE_EXIT_CODE}" -ne 0 ]]; then
		printf "!ERROR! apt-get return with errors\n" 1>&2
		exit 1
	fi
	
	PACKAGE_LIST_FILE="${RECIPE_DIRECTORY}/packages.install.list"
	
	# Build APT_PACKAGE_LIST_FILES and MISSING_PACKAGE_LIST_FILE from PACKAGE_LIST_FILE
	APT_PACKAGE_LIST_FILE_NAME_PREFIX="${RECIPE_DIRECTORY}/apt_package_list"
	if [[ -f "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}" ]]; then
		rm -f "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}"
	fi
	MISSING_PACKAGE_LIST_FILE="${RECIPE_DIRECTORY}/packages.missing.list"
	if [[ -f "${MISSING_PACKAGE_LIST_FILE}" ]]; then
		rm -f "${MISSING_PACKAGE_LIST_FILE}"
	fi
	
	cd "${RECIPE_DIRECTORY}"
	generate_apt_package_list_files "${PACKAGE_LIST_FILE}" "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}" "${MISSING_PACKAGE_LIST_FILE}"
	
	# Exit if some packages are missing
	if [[ -f "${MISSING_PACKAGE_LIST_FILE}" ]] && [[ -s "${MISSING_PACKAGE_LIST_FILE}" ]]; then
		printf "Some packages are missing\n"
		printf "See MISSING_PACKAGE_LIST_FILE: ${MISSING_PACKAGE_LIST_FILE}\n"
		rm -f "${APT_PACKAGE_LIST_FILE}"
		exit 1
	fi
	
	# Proceed to install with --force-confnew
	# Always install the new version of the configuration file, the current version is kept in a file with the .dpkg-old suffix
	# DEBIAN_FRONTEND_TO_USE is supposed to be set in felix.conf, it can be valued `noninteractive` or `readline`.
	: "${DEBIAN_FRONTEND_TO_USE:=readline}"
	for APT_PACKAGE_FILE_LIST in "${APT_PACKAGE_LIST_FILE_NAME_PREFIX}"*; do
		DEBIAN_FRONTEND=${DEBIAN_FRONTEND_TO_USE} xargs apt-get -o Dpkg::Options::=--force-confnew -y install <"${APT_PACKAGE_FILE_LIST}"
	done
	
	# Cleanup
	rm -f "${APT_PACKAGE_LIST_FILE}"
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

process_package_install_list 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
