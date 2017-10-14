#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

install_customized_faenza(){
	echo "Installing customized Faenza... "
	
	cd ${BASEDIR}
	git clone http://github.com/Kazhnuz/faenza-vanilla-icon-theme
	rm -fr ./faenza-vanilla-icon-theme/Faenza/status
	cp -R ./faenza-vanilla-icon-theme/Faenza-Dark/status ./faenza-vanilla-icon-theme/Faenza/status
	
	# synaptic persists to use its 16x16 icon. Dirty fix: replace the 16x16 by the 32x32
	renameFileForBackup ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	ln -s ./faenza-vanilla-icon-theme/Faenza/apps/32/synaptic.png ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	
	sed -i "/^Name=/s/.*/Name=Faenza-njames/" ./faenza-vanilla-icon-theme/Faenza/index.theme
	ESCAPED_COMMENT=$(escape_sed_pattern "Comment=Icon theme project downloaded from https://github.com/Kazhnuz/faenza-vanilla-icon-theme and modified by njames")
	sed -i "/^Comment=/s/.*/${ESCAPED_COMMENT}/" ./faenza-vanilla-icon-theme/Faenza/index.theme
	mv ./faenza-vanilla-icon-theme/Faenza ./faenza-vanilla-icon-theme/Faenza-njames
	
	cp -R ./faenza-vanilla-icon-theme/Faenza-njames
	
	update-icon-caches /usr/share/icons
}

cd ${BASEDIR}
install_customized_faenza 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
