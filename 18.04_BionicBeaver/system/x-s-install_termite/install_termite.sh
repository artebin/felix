#!/usr/bin/env bash

# This recipe has been disabled because termite has problems with SSH <https://github.com/thestinger/termite/issues/229>

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_termite(){
	cd ${BASEDIR}
	
	echo "Installing Termite ..."
	echo "Installation procedure retrieved from <https://github.com/Corwind/termite-install>"
	
	apt-get install -y \
	git \
	g++ \
	libgtk-3-dev \
	gtk-doc-tools \
	gnutls-bin \
	valac \
	intltool \
	libpcre2-dev \
	libglib3.0-cil-dev \
	libgnutls28-dev \
	libgirepository1.0-dev \
	libxml2-utils \
	gperf
	
	git clone --recursive https://github.com/thestinger/termite.git
	git clone https://github.com/thestinger/vte-ng.git
	
	echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
	cd vte-ng
	./autogen.sh
	make
	make install
	
	cd ../termite
	make
	make install
	ldconfig
	mkdir -p /lib/terminfo/x
	ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
	
	update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60
	
	# Clean
	cd ${BASEDIR}
	rm -fr ./termite
	rm -fr ./vte-ng
}

cd ${BASEDIR}
install_termite 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
exit "${EXIT_CODE}"
