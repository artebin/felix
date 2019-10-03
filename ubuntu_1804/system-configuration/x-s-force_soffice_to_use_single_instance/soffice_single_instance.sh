#!/usr/bin/env bash

USER_INSTALLATION_DIR="/tmp/njames/soffice"
if [[ ! -d "${USER_INSTALLATION_DIR}" ]]; then
	mkdir -p "${USER_INSTALLATION_DIR}"
fi
TIMESTAMP=$(date -u +'%y%m%d_%H%M%S.%3N')
soffice --accept="pipe,name=soffice-pipe-uuid;urp;StarOffice.ServiceManager" -env:UserInstallation="file:///tmp/njames/soffice/${TIMESTAMP}" ${@}
