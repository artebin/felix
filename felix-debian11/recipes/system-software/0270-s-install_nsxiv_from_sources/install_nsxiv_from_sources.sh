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

install_nsxiv_from_sources(){
	printf "Install nsxiv from sources...\n"
	
	# Install dependencies
	DEPENDENCIES=(
		libwebp-dev
		libxft-dev
		libexif-dev
		libinotifytools0-dev
		libgif-dev
		)
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repositories
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/nsxiv/nsxiv
	git clone https://github.com/nsxiv/nsxiv-extra
	
	# Build
	cd "${RECIPE_DIRECTORY}"
	cd nsxiv
	make
	make install
	cp nsxiv.desktop /usr/local/share/applications/
	
	# Copy nsxiv-rifle to /usr/local/bin
	printf "Make nsxiv.desktop call nsxiv-rifle...\n"
	cd "${RECIPE_DIRECTORY}"
	cp ./nsxiv-extra/scripts/nsxiv-rifle/nsxiv-rifle /usr/local/bin/nsxiv-rifle
	chmod +x /usr/local/bin/nsxiv-rifle
	add_or_update_keyvalue /usr/local/share/applications/nsxiv.desktop "Exec" "nsxiv-rifle %%F"
	update-desktop-database
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr nsxiv
	rm -fr nsxiv-extra
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_nsxiv_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
