#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_geany_markdown_plugin(){
	cd ${BASEDIR}
	
	echo "Install Geany / Markdown plugin ..."
	apt install -y libwebkit2gtk-4.0-dev
	git clone http://github.com/geany/geany-plugins
	cd geany-plugins
	./autogen.sh
	./configure
	cd markdown
	make
	make install
	
	# Clean
	cd ${BASEDIR}
	rm -fr ./geany-plugins
}

cd ${BASEDIR}
install_geany_markdown_plugin 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
