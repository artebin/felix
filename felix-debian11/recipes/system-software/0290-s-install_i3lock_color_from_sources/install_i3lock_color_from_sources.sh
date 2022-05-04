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

install_i3lock_color_from_sources(){
	printf "Install i3lock-color from sources...\n"
	
	# Install dependencies
	DEPENDENCIES=(  autoconf
			gcc
			make
			pkg-config
			libpam0g-dev
			libcairo2-dev
			libfontconfig1-dev
			libxcb-composite0-dev
			libev-dev
			libx11-xcb-dev
			libxcb-xkb-dev
			libxcb-xinerama0-dev
			libxcb-randr0-dev
			libxcb-image0-dev
			libxcb-util-dev
			libxcb-xrm-dev
			libxkbcommon-dev
			libxkbcommon-x11-dev
			libjpeg-dev )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repositories
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/Raymo111/i3lock-color
	
	# Build
	cd "${RECIPE_DIRECTORY}"
	cd i3lock-color
	./install-i3lock-color.sh
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr i3lock-color
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_i3lock_color_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
