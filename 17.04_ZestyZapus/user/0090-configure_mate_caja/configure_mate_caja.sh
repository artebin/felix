#!/bin/bash

source ../../common.sh
check_shell

configure_mate_caja(){
	cd ${BASEDIR}
	
	echo "Configuring mate-caja ..."
	dconf load /org/mate/caja/ < ./org.mate.caja.dump
}

cd ${BASEDIR}
configure_mate_caja 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
