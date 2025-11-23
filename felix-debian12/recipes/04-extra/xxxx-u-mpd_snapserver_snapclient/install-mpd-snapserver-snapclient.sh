#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash

function install_mpd(){
	printf "Installing MPD... \n"
	
	sudo apt-get mpd
	sudo systemctl stop mpd
	sudo systemctl disable mpd
	mkdir -p "${HOME}/.config/mpd"
	backup_file rename "${HOME}/.config/mpd/mpd.conf"
	gunzip -c /usr/share/doc/mpd/mpdconf.example.gz "${HOME}/.config/mpd"
	sed -i "s|~/.mpd/|~/.config/mpd/|g"
	
	cat << EOF
Add the audio output below to mpd.conf as input for Snapcast:
audio_output {
	type		"fifo"
	encoder		"flac"
	name		"snapserver"
	format		"44100:16:2"
	path		"/tmp/snapfifo"
	compression	"8"
	mixer_type	"software"
}
EOF
	
	mkdir -p "${HOME}/.config/systemd/user"
	
	cat << EOF
Enable and start the MPD service:
Systemctl --user enable mpd
systemctl --user start mpd
EOF
	
	printf "\n"
}

function install_mpd_scribble(){
	printf "Installing MPD Scribble... \n"
	
	sudo apt-get install mpdscribble
	
	mkdir -p "${HOME}/.config/mpd"
	backup_file rename "${HOME}/.config/mpd/mpdscribble.conf"
	sudo cp /etc/mpdscribbler.conf "${HOME}/.config/mpd/mpdscribller.conf"
	sudo chown "${USER}":"${USER}" "${HOME}/.config/mpd/mpdscribller.conf"
	
	mkdir -p "${HOME}/.config/systemd/user"
	cp mpdscribble.service "${HOME}/.config/systemd/user"
	
	cat << EOF
Enable and start the MPD Scribble service:
Systemctl --user enable mpdscribble
systemctl --user start mpdscribble
EOF
	
	printf "\n"
}

function install_snapserver(){
	printf "Installing Snapcast server... \n"
	
	sudo apt-get install snapserver
	mkdir -p "${HOME}/.config/snapserver"
	cp /etc/snapserver.conf "${HOME}/.config/snapserver"
	
	cat << EOF
Enable the TCP RPC in snapserver.conf and add the MPD source below:
source = pipe:///tmp/snapfifo?name=mpdapollo&sampleformat=44100:16:2&codec=flac
EOF
	
	mkdir -p "${HOME}/.config/systemd/user"
	cp snapserver.service "${HOME}/.config/systemd/user"
	
	cat << EOF
Enable and start the snapserver service:
Systemctl --user enable snapserver
systemctl --user start snapserver
EOF
	
	printf "\n"
}

function install_snapclient(){
	printf "Installing Snapcast client... \n"
	
	sudo apt-get install snapclient
	
	mkdir -p "${HOME}/.config/systemd/user"
	cp snapclient.service "${HOME}/.config/systemd/user"
	
	cat << EOF
Enable and start the snapclient service:
Systemctl --user enable snapclient
systemctl --user start snapclient
EOF
	
	printf "\n"
}

install_mpd 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_mpd_scribble 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_snapserver 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

install_snapclient 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
