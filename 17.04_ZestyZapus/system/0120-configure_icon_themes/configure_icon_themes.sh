#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

install_customized_faenza(){
	cd ${BASEDIR}
	
	echo "Cloning Faenza from http://github.com/Kazhnuz/faenza-vanilla-icon-theme ..."
	git clone http://github.com/Kazhnuz/faenza-vanilla-icon-theme
	
	echo "Fix status icons for dark theme ..."
	rm -fr ./faenza-vanilla-icon-theme/Faenza/status
	cp -R ./faenza-vanilla-icon-theme/Faenza-Dark/status ./faenza-vanilla-icon-theme/Faenza/status
	
	echo "synaptic persists to use its 16x16 icon => dirty fix: replace the 16x16 by the 32x32 ..."
	renameFileForBackup ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	ln -s ./faenza-vanilla-icon-theme/Faenza/apps/32/synaptic.png ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	
	echo "Installing our customized Faenza ... "
	sed -i "/^Name=/s/.*/Name=Faenza-njames/" ./faenza-vanilla-icon-theme/Faenza/index.theme
	ESCAPED_COMMENT=$(escape_sed_pattern "Comment=Icon theme project downloaded from https://github.com/Kazhnuz/faenza-vanilla-icon-theme and modified by njames")
	sed -i "/^Comment=/s/.*/${ESCAPED_COMMENT}/" ./faenza-vanilla-icon-theme/Faenza/index.theme
	mv ./faenza-vanilla-icon-theme/Faenza ./faenza-vanilla-icon-theme/Faenza-njames
	cp -R ./faenza-vanilla-icon-theme/Faenza-njames /usr/share/icons
	
	echo "Updating icon caches ..."
	update-icon-caches /usr/share/icons
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr ./faenza-vanilla-icon-theme
}

cd ${BASEDIR}
install_customized_faenza 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
