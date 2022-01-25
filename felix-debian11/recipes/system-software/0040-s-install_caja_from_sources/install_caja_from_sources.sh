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

install_caja_from_sources(){
	printf "Installing dependencies ...\n"
	DEPENDENCIES=(  "gtk-doc-tools"
			"gobject-introspection"
			"autoconf-archive"
			"libgail-3-dev"
			"libmate-desktop-dev"
			"yelp-tools" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	printf "Installing mate-common from sources ...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone "https://github.com/mate-desktop/mate-common"
	cd mate-common
	ACLOCAL_FLAGS="-I /usr/share/aclocal -I /usr/local/share/aclocal" ./autogen.sh --prefix=/usr
	make
	make install
	
	printf "Installing caja from sources ...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone --recurse-submodules https://github.com/mate-desktop/caja.git
	cd caja
	ACLOCAL_FLAGS="-I /usr/share/aclocal -I /usr/local/share/aclocal" ./autogen.sh --prefix=/usr
	make
	make install
	
	printf "Installing caja-extensions from sources...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone "https://github.com/mate-desktop/caja-extensions"
	cd caja-extensions
	ACLOCAL_FLAGS="-I /usr/share/aclocal -I /usr/local/share/aclocal" ./autogen.sh --prefix=/usr
	make
	make install
	
	printf "Installing libgtop required for caja-actions from sources...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone "https://gitlab.gnome.org/GNOME/libgtop"
	cd libgtop
	./autogen.sh
	make
	make install
	
	printf "Installing caja-actions from sources...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone "https://github.com/mate-desktop/caja-actions"
	cd caja-actions
	ACLOCAL_FLAGS="-I /usr/share/aclocal -I /usr/local/share/aclocal" ./autogen.sh --prefix=/usr
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	#rm -fr mate-common
	#rm -fr caja
	#rm -fr caja-extension
	#rm -fr libgtop
	#rm -fr caja-actions
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
install_caja_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
