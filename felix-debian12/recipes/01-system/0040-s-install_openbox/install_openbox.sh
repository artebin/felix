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
	printf "Install openbox...\n"
	install_package_if_not_installed "openbox" "obconf"
	printf "\n"
}

function install_openbox_3_6_1_from_sources(){
	printf "Retrieve sources for openbox package and install build dependencies...\n"
	mkdir debian-openbox
	cd "${RECIPE_DIRECTORY}"/debian-openbox
	apt-get source openbox/stable
	if [[ ! -d "openbox-3.6.1" ]]; then
		printf "!ERROR! Cannot find openbox-3.6.1 directory\n"
		exit 1
	fi
	apt-get build-dep -y openbox/stable
	install_package_if_not_installed "devscripts"
	
	printf "Apply patch for claiming the support of GTK_FRAME_EXTENTS from <https://github.com/jalopezg-git/openbox>...\n"
	cd "${RECIPE_DIRECTORY}"/debian-openbox/openbox-3.6.1
	patch -p1 < "${RECIPE_DIRECTORY}"/openbox-claim-gtk_frame_extents.patch
	EDITOR=/bin/true dpkg-source -q --commit . gtk_frame_extents
	
	printf "Apply patch for ignoring size inc hints...\n"
	cd "${RECIPE_DIRECTORY}"/debian-openbox/openbox-3.6.1
	patch -p0 < "${RECIPE_DIRECTORY}"/openbox-ignore-size-inc-hints.patch
	EDITOR=/bin/true dpkg-source -q --commit . ignore_size_inc_hints
	
	printf "Build and install openbox...\n"
	cd "${RECIPE_DIRECTORY}"/debian-openbox/openbox-3.6.1
	debuild -us -uc
	
	cd "${RECIPE_DIRECTORY}"/debian-openbox
	dpkg -i libob* openbox_3.6.1-10_amd64.deb openbox-dbgsym_3.6.1-10_amd64.deb openbox-dev_3.6.1-10_amd64.deb
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr debian-openbox
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if false; then
	install_openbox 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	install_openbox_3_6_1_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
fi
