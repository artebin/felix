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

DOKUWIKI_STABLE="dokuwiki-2017-02-19e"
USERNAME=$(whoami)

install_dokuwiki_in_userdir(){
	echo "Installing DokuWiki in userdir ..."
	
	sudo adduser www-data "${USERNAME}"
	
	mkdir -p "${HOME}/public_html"
	cd "${RECIPE_DIR}"
	cp dokuwiki-stable.tgz "${HOME}/public_html/dokuwiki-stable.tgz"
	
	cd "${HOME}/public_html"
	tar xzf dokuwiki-stable.tgz
	
	cd "${RECIPE_DIR}"
	cp dokubook-stable.tgz "${HOME}/public_html/${DOKUWIKI_STABLE}/lib/tpl"
	cp conf/mime.local.conf "${HOME}/public_html/${DOKUWIKI_STABLE}/conf"
	cp conf/entities.conf "${HOME}/public_html/${DOKUWIKI_STABLE}/conf"
	cp conf/userstyle.css "${HOME}/public_html/${DOKUWIKI_STABLE}/conf"
	cp conf/userscript.js "${HOME}/public_html/${DOKUWIKI_STABLE}/conf"
	
	cd "${HOME}/public_html/${DOKUWIKI_STABLE}/lib/tpl"
	tar xzf dokubook-stable.tgz
	chmod -R g+r "${HOME}/public_html"
	chmod -R g+w "${HOME}/public_html/${DOKUWIKI_STABLE}/data"
	find "${HOME}/public_html" -type d | xargs chmod g+x
	sudo service apache2 restart
	
	echo
}

install_dokuwiki_in_userdir 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

x-www-browser "http://localhost/~${USERNAME}/${DOKUWIKI_STABLE}/install.php" &
