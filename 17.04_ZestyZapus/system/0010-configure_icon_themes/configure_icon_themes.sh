#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

install_bunsen_faenza(){
	echo "Installing bunsen-faenza-icon-theme ..."
	
	cd ${BASEDIR}
	git clone https://github.com/BunsenLabs/bunsen-faenza-icon-theme
	cd bunsen-faenza-icon-theme
	tar xzf bunsen-faenza-icon-theme.tar.gz
	cp -r ./Faenza-Bunsen /usr/share/icons/
	cp -r ./Faenza-Bunsen-common /usr/share/icons
	cp -r ./Faenza-Dark-Bunsen /usr/share/icons
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr bunsen-faenza-icon-theme
	
	# Custumization: status icons are black but we want have them gray (tint2)
	rm -fr /usr/share/icon/Faenza-Bunsen/status
	cp -r /usr/share/icon/Faenza-Dark/state /usr/share/icons/Faenza-Bunsen
	
	update-icon-caches /usr/share/icons
}

customize_faenza(){
	# synaptic persists to use its 16x16 icon
	mv /usr/share/icons/Faenza/apps/16/synaptic.png /usr/share/icons/Faenza/apps/16/synaptic.png.bak
	ln -s /usr/share/icons/Faenza/apps/32/synaptic.png /usr/share/icons/Faenza/apps/16/synaptic.png
}

cd ${BASEDIR}
customize_faenza 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
