#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_rofi_from_sources(){
	echo "Install rofi from sources ..."
	
	# Install dependencies
	DEPENDENCIES=(  "bison" 
					"flex" 
					"libxcb-xkb-dev"
					"libxcb-ewmh-dev"
					"libxcb-icccm4-dev"
					"libxcb-xrm-dev"
					"libxcb-xinerama0-dev"
					"libxkbcommon-x11-dev"
					"libstartup-notification0-dev"
					"librsvg2-dev" )
	install_package_if_not_installed ${DEPENDENCIES[@]}
	
	# Clone git repository
	cd ${BASEDIR}
	git clone https://github.com/DaveDavenport/rofi
	cd rofi
	git submodule update --init #Pull dependencies
	
	# Build
	cd ${BASEDIR}
	cd rofi
	autoreconf -i
	mkdir build
	cd build
	../configure
	make
	make install
	
	#~ # Cleaning
	cd ${BASEDIR}
	rm -fr rofi
	
	echo
}

install_check_from_sources(){
	echo "Install check from sources (check >= 0.11.0 is a dependency of rofi) ..."
	
	# Install dependencies
	install_package_if_not_installed "texinfo"
	
	# Clone git repository
	cd ${BASEDIR}
	git clone https://github.com/libcheck/check
	
	# Compile and install
	cd ${BASEDIR}
	cd check
	autoreconf -i
	./configure
	make check
	make install
	ldconfig
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr check
	
	echo
}

cd ${BASEDIR}
install_check_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
install_rofi_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
