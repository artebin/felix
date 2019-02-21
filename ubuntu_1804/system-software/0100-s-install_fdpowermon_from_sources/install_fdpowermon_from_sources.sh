#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_fdpowermon_from_sources(){
	echo "Install fdpowermon from sources ..."
	
	# Remove packages 'fdpowermon' and 'fdpowermon-icons' if already 
	# installed.
	remove_with_purge_package_if_installed "fdpowermon" "fdpowermon-icons"
	
	# Install dependencies
	install_package_if_not_installed "acpi" "devscripts" "libgtk3-perl"
	
	# Create a directory 'fdpowermon-build' because we will call
	# 'dpkg-buildpackage' and its output directory is always the
	# parent directory.
	cd "${RECIPE_DIR}"
	mkdir fdpowermon-build
	cd fdpowermon-build
	
	# Clone git repository
	git clone https://github.com/yoe/fdpowermon
	
	# Build the package
	cd fdpowermon
	dpkg-buildpackage
	
	# Install the package
	cd "${RECIPE_DIR}/fdpowermon-build"
	dpkg -i fdpowermon_*.deb
	
	# The package 'fdpowermon-icons' installs a few icons of the
	# oxygen icon theme, but this theme could be installed already.
	if ! $(is_package_installed "oxygen-icon-theme"); then
		dpkg -i fdpowermon-icons_*.deb
	fi
	
	# Cleaning
	cd "${RECIPE_DIR}"
	rm -fr fdpowermon-build
	
	echo
}

cd "${RECIPE_DIR}"
install_fdpowermon_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
