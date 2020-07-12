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

install_claws_mail_from_sources(){
	echo "Install Claws Mail from sources ..."
	
	# Install dependencies
	echo "Install dependencies for compilation ..."
	DEPENDENCIES=(  "libetpan-dev" \
					"libenchant-dev" \
					"libgdata-dev" \
					"libwebkitgtk-3.0-dev" \
					"libwebkitgtk-dev"
					"libdbus-glib-1-dev"
					"compface"
					"libcompfaceg1-dev"
					"libgpg-error-dev"
					"libgpgme-dev"
					"libnm-dev"
					"libnm-glib-dev"
					"libnm-glib-vpn-dev"
					"libnm-gtk-dev"
					"python-all-dev"
					"python-gtk2-dev"
					"libarchive-dev"
					"libpoppler-glib-dev"
					"libperl-dev"
					"libytnef0-dev"
					"libical-dev"
					"librsvg2-dev"
					"docbook"
					"libstartup-notification0-dev"
					"libsoup-gnome2.4-dev"
					"libcanberra-gtk-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Download and unpack the sources
	cd "${RECIPE_DIRECTORY}"
	SOURCES_URL="https://www.claws-mail.org/download.php?file=releases/claws-mail-3.17.3.tar.bz2"
	SOURCES_PKG_FILE="claws-mail-3.17.3.tar.bz2"
	SOURCES_DIR="claws-mail-3.17.3"
	wget --quiet --content-disposition "${SOURCES_URL}"
	tar xjf "${SOURCES_PKG_FILE}"
	
	# Compile and install
	cd "${RECIPE_DIRECTORY}/${SOURCES_DIR}"
	./configure
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr "${SOURCES_DIR}"
	rm -fr "${SOURCES_PKG_FILE}"
	
	echo
}

cd "${RECIPE_DIRECTORY}"
install_claws_mail_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
