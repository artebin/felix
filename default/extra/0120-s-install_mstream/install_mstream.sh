#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_mstream(){
	printf "Installing NodeJS and git...\n"
	curl -sL "https://deb.nodesource.com/setup_12.x" | bash -
	apt-get install -y nodejs git
	
	printf "Installing mstream...\n"
	git clone https://github.com/IrosTheBeggar/mStream.git
	cd mStream
	npm install --only=production
	npm link
	
	printf "Adding mstream user and installing start_stream.sh...\n"
	useradd mstream
	mkdir /home/mstream
	cp ./config.json /home/mstream/config.json
	cp ./start_mstream.sh /home/mstream
	chown -R mstream:mstream /home/mstream
	chmod 0700 /home/mstream/start_mstream.sh
	
	printf "Autostarting mstream at boot time...\n"
	cp ./mstream.service /etc/systemd/system
	systemctl --system daemon-reload
	systemctl enable mstream.service
	systemctl status mstream.service
	
	# Cleaning
	rm -fr mStream
	
	printf "\n"
}

install_mstream 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
