#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix-common.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix-common.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

function install_fdpowermon(){
	printf "Install fdpowermon...\n"
	install_package_if_not_installed "fdpowermon"
	printf "\n"
}

function install_fdpowermon_from_sources(){
	printf "Remove packages 'fdpowermon' and 'fdpowermon-icons' if already installed...\n"
	remove_with_purge_package_if_installed "fdpowermon" "fdpowermon-icons"
	
	printf "Install required dependencies to build fdpowermon...\n"
	install_package_if_not_installed "acpi" "devscripts" "libgtk3-perl" "oxygen-icon-theme"
	
	printf "Build and install fdpowermon from <https://github.com/yoe/fdpowermon>...\n"
	
	# Create a directory 'fdpowermon-build' because we will call
	# 'dpkg-buildpackage' and its output directory is always the
	# parent directory.
	cd "${RECIPE_DIRECTORY}"
	mkdir fdpowermon-build
	cd fdpowermon-build
	
	# Clone git repository
	git clone https://github.com/yoe/fdpowermon
	
	# Build the package
	cd fdpowermon
	dpkg-buildpackage
	
	# Install the package
	cd "${RECIPE_DIRECTORY}/fdpowermon-build"
	dpkg -i fdpowermon_*.deb
	
	# The package 'fdpowermon-icons' installs a few icons of the
	# oxygen icon theme, but this theme could be installed already.
	if ! $(is_package_installed "oxygen-icon-theme"); then
		dpkg -i fdpowermon-icons_*.deb
	fi
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr fdpowermon-build
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_fdpowermon 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_fdpowermon_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
