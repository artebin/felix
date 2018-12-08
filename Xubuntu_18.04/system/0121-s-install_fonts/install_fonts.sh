#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_additional_fonts(){
	cd ${BASEDIR}
	
	echo "Installing additional fonts ..."
	cp ./fonts/Droid/*.ttf /usr/local/share/fonts/
	cp ./fonts/Montserrat/*.otf /usr/local/share/fonts/
	cp ./fonts/Roboto/*.ttf /usr/local/share/fonts/
	
	echo "Updating font cache ..."
	fc-cache -f -v 1>/dev/null
}

cd ${BASEDIR}
install_additional_fonts 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
