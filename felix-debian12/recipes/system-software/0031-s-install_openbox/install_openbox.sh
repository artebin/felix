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

function install_openbox(){
	printf "Install caja...\n"
	install_package_if_not_installed "openbox obconf"
	printf "\n"
}

function install_openbox_from_sources(){
	printf "Retrieve Debian sources for openbox package and install build dependencies...\n"
	cd "${RECIPE_DIRECTORY}"
	apt-get source openbox/stable
	sudo apt-get build-dep openbox/stable
	
	printf "Apply patch for GTK_FRAME_EXTENTS from <https://github.com/jalopezg-git/openbox>...\n"
	cd "${RECIPE_DIRECTORY}"
	GTK_FRAME_EXTENTS_COMMIT_SHA="d5a0e47025cf1a002f827740cc77d84f71d0d7aa"
	curl https://github.com/jalopezg-git/openbox/commit/${GTK_FRAME_EXTENTS_COMMIT_SHA}.patch/ >${GTK_FRAME_EXTENTS_COMMIT_SHA}.patch
	cd openbox-3.6.1
	patch -p1 < ../${GTK_FRAME_EXTENTS_COMMIT_SHA}.patch
	dpkg-source --commit
	debuild -us -uc
	
	# then we can add the changes with $dpkg-source --commit
	# then build the package with $debuild -us -uc
	# then install the package
	
	# We do not build obconf from sources but install it from Debian repository
	#install_package_if_not_installed "obconf"
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_openbox 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_openbox_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
