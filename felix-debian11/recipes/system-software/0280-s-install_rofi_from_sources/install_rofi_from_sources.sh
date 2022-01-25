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

install_check_from_sources(){
	printf "Install check from sources (check >= 0.11.0 is a dependency of rofi) ...\n"
	
	# Install dependencies
	install_package_if_not_installed "texinfo libxcb-randr0-dev"
	
	# Clone git repository
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/libcheck/check
	
	# Compile and install
	cd "${RECIPE_DIRECTORY}"
	cd check
	autoreconf -i
	./configure
	make check
	make install
	ldconfig
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr check
	
	printf "\n"
} 

install_rofi_from_sources(){
	printf "Install rofi from sources ...\n"
	
	# Install dependencies
	DEPENDENCIES=(  "bison" 
			"flex" 
			"libxcb-xkb-dev"
			"libxcb-cursor-dev"
			"libxcb-ewmh-dev"
			"libxcb-icccm4-dev"
			"libxcb-xrm-dev"
			"libxcb-xinerama0-dev"
			"libxkbcommon-x11-dev"
			"libstartup-notification0-dev"
			"librsvg2-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repository
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/DaveDavenport/rofi
	cd rofi
	git submodule update --init #Pull dependencies
	
	# Build
	cd "${RECIPE_DIRECTORY}"
	cd rofi
	autoreconf -i
	mkdir build
	cd build
	../configure
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr rofi
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_check_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

cd "${RECIPE_DIRECTORY}"
install_rofi_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
