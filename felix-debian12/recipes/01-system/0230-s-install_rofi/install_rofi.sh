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

function install_rofi(){
	printf "Install rofi...\n"
	install_package_if_not_installed "rofi"
	printf "\n"
}

# check >= 0.11.0 is a dependency of rofi so we might have to install it from sources too
function install_check_from_sources(){
	printf "Install required dependencies to build check...\n"
	install_package_if_not_installed "texinfo" "libxcb-randr0-dev"
	
	printf "Build and install check...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/libcheck/check
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

function install_rofi_from_sources(){
	printf "Install required dependencies to build rofi...\n"
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
	
	printf "Build and install rofi from <https://github.com/DaveDavenport/rofi>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/DaveDavenport/rofi
	cd rofi
	git submodule update --init #Pull dependencies
	cd rofi
	autoreconf -i
	mkdir build
	cd build
	../configure
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr rofi
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

if [[ "${FELIX_RECIPE_BUILD_FROM_SOURCES_ARRAY[${RECIPE_ID}]}" != "true" ]]; then
	install_rofi 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
		exit "${EXIT_CODE}"
	fi
else
	# Debian12 provides at least check v0.15.2 so we do not need to build it anymore and we comment the lines below.
	#install_check_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	#EXIT_CODE="${PIPESTATUS[0]}"
	#if [[ "${EXIT_CODE}" -ne 0 ]]; then
	#	exit "${EXIT_CODE}"
	#fi
	
	install_rofi_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
	EXIT_CODE="${PIPESTATUS[0]}"
	if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
	fi
fi
