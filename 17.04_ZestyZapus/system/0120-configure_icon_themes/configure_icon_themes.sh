#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_customized_faenza(){
	cd "${BASEDIR}"
	
	echo 'Cloning Faenza from http://github.com/Kazhnuz/faenza-vanilla-icon-theme ...'
	git clone http://github.com/Kazhnuz/faenza-vanilla-icon-theme
	
	echo 'Fix status icons for dark theme ...'
	rm -fr './faenza-vanilla-icon-theme/Faenza/status'
	cp -R './faenza-vanilla-icon-theme/Faenza-Dark/status' './faenza-vanilla-icon-theme/Faenza/status'
	
	echo 'Installing our customized Faenza ...'
	sed -i '/^Name=/s/.*/Name=Faenza-njames/' './faenza-vanilla-icon-theme/Faenza/index.theme'
	ESCAPED_COMMENT=$(escape_sed_pattern 'Comment=Icon theme project downloaded from https://github.com/Kazhnuz/faenza-vanilla-icon-theme and modified by njames')
	sed -i "/^Comment=/s/.*/${ESCAPED_COMMENT}/" './faenza-vanilla-icon-theme/Faenza/index.theme'
	mv './faenza-vanilla-icon-theme/Faenza' './faenza-vanilla-icon-theme/Faenza-njames'
	cp -R './faenza-vanilla-icon-theme/Faenza-njames' '/usr/share/icons'
	
	echo 'synaptic persists to use its 16x16 icon => dirty fix: replace the 16x16 by the 32x32 ...'
	cd '/usr/share/icons/Faenza-njames/apps/16'
	backup_file rename './synaptic.png'
	ln -s '../32/synaptic.png' './synaptic.png'
	
	echo 'Updating icon caches ...'
	update-icon-caches '/usr/share/icons'
	
	# Cleanup
	cd "${BASEDIR}"
	rm -fr './faenza-vanilla-icon-theme'
}

cd "${BASEDIR}"
install_customized_faenza 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
