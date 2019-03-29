#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

install_dokuwiki_in_userdir(){
	printf "Installing DokuWiki in apache2 userdir ...\n"
	
	APACHE2_USERDIR="${HOME}/public_html"
	DOKUWIKI_INSTALL_DIR="${APACHE2_USERDIR}/dokuwiki"
	
	if [[ -d "${DOKUWIKI_INSTALL_DIR}" ]]; then
		printf "DOKUWIKI_INSTALL_DIR already exists: ${DOKUWIKI_INSTALL_DIR}\n"
		exit 1
	fi
	
	# Download DokuWiki stable release
	cd "${APACHE2_USERDIR}"
	DOKUWIKI_ARCHIVE_NAME="dokuwiki-stable.tgz"
	if [[ -f "${DOKUWIKI_ARCHIVE_NAME}" ]]; then
		printf "DOKUWIKI_ARCHIVE_NAME already exists: ${DOKUWIKI_ARCHIVE_NAME}\n"
		exit 1
	fi
	DOKUWIKI_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
	wget --quiet "${DOKUWIKI_URL}"
	
	# Install
	cd "${APACHE2_USERDIR}"
	DOKUWIKI_DIR_NAME=$(tar -tzf "${DOKUWIKI_ARCHIVE_NAME}" | head -1 | cut -f1 -d"/")
	tar xzf "${DOKUWIKI_ARCHIVE_NAME}"
	mv "${DOKUWIKI_DIR_NAME}" dokuwiki
	
	# Adding template dokubook
	cd "${RECIPE_DIR}"
	cp dokubook-stable.tgz "${DOKUWIKI_INSTALL_DIR}/lib/tpl"
	cd "${DOKUWIKI_INSTALL_DIR}/lib/tpl"
	tar xzf dokubook-stable.tgz
	
	# Adding own configuration
	cd "${RECIPE_DIR}"
	cp conf/mime.local.conf "${DOKUWIKI_INSTALL_DIR}/conf"
	cp conf/entities.conf "${DOKUWIKI_INSTALL_DIR}/conf"
	cp conf/userstyle.css "${DOKUWIKI_INSTALL_DIR}/conf"
	cp conf/userscript.js "${DOKUWIKI_INSTALL_DIR}/conf"
	
	# Setting rights
	sudo adduser www-data "${USER}"
	chmod -R g+r "${HOME}/public_html"
	chmod -R g+w "${DOKUWIKI_INSTALL_DIR}/conf"
	chmod -R g+w "${DOKUWIKI_INSTALL_DIR}/data"
	find "${HOME}/public_html" -type d | xargs chmod g+x
	
	# Restart apache2
	sudo service apache2 restart
	
	printf "\n"
}

install_dokuwiki_in_userdir 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi