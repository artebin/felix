#!/usr/bin/env bash

source ../../common.sh
check_shell

configure_default_applications(){
	cd ${BASEDIR}
	
	# Note: the .desktop can be found in /usr/share/applications
	
	echo "Configuring mate-caja as default file browser ..."
	mkdir -p ~/.local/share/applications
	cp ./caja.desktop ~/.local/share/applications/caja.desktop
	xdg-mime default caja.desktop inode/directory
	
	echo "Removing some MIME types declared by LibreOffice which is quite aggressive on this regard ... "
	cp /usr/share/applications/libreoffice-*.desktop ~/.local/share/applications
	SED_PATTERN=";text/plain;"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern "${SED_PATTERN}")
	sed -i.bak "s/${ESCAPED_SED_PATTERN}/;/g" ~/.local/share/applications/libreoffice-writer.desktop
	
	echo "Removing all MIME types declared by Vim ..."
	cp /usr/share/applications/vim.desktop ~/.local/share/applications
	sed -i.bak "s/MimeType=.*/MimeType=/g" ~/.local/share/applications/vim.desktop
	
	echo "Configuring thunderbird as default mail client ..."
	xdg-mime default thunderbird.desktop x-scheme-handler/mailto
}

cd ${BASEDIR}
configure_default_applications 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
