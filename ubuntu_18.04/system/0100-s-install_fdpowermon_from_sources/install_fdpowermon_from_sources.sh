#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_fdpowermon_from_sources(){
	echo "Installing fdpowermon from sources ..."
	
	# Remove packages 'fdpowermon' and 'fdpowermon-icons' if already 
	# installed.
	remove_with_purge_package_if_installed "fdpowermon" "fdpowermon-icons"
	
	# Install dependencies
	install_package_if_not_installed "acpi" "devscripts" "libgtk3-perl"
	
	# Create a directory 'fdpowermon-build' because we will call
	# 'dpkg-buildpackage' and its output directory is always the
	# parent directory.
	cd ${BASEDIR}
	mkdir fdpowermon-build
	cd fdpowermon-build
	
	# Clone git repository
	git clone https://github.com/yoe/fdpowermon
	
	# Build the package
	cd fdpowermon
	dpkg-buildpackage
	
	# Install the packages
	cd ${BASEDIR}/fdpowermon-build
	dpkg -i fdpowermon_*.deb
	
	# The package 'fdpowermon-icons' installs a few icons of the
	# oxygen icon theme, but this theme could be installed already.
	if ! $(is_package_installed "oxygen-icon-theme"); then
		dpkg -i fdpowermon-icons_*.deb
	fi
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr fdpowermon-build
	
	echo
}

cd ${BASEDIR}
install_fdpowermon_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
