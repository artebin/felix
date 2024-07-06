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
exit_if_has_not_root_privileges

disable_startup_chime(){
	echo "Disabling startup chime ..."
	
	# See <https://linux-tips.com/t/disable-startup-sound-of-macbook-and-imac/606/2>
	
	SYSTEM_AUDIO_VOLUME_PATH="/sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82"
	if [[ ! -f "${SYSTEM_AUDIO_VOLUME_PATH}" ]]; then
		touch "${SYSTEM_AUDIO_VOLUME_PATH}"
	fi
	
	# Some variable are immutable by default in /sys/firware/efi/efivars notably 'SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82'
	# See <https://www.linuxtechi.com/file-directory-attributes-in-linux-using-chattr-lsattr-command>
	lsattr /sys/firmware/efi/efivars
	chattr -i "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	printf "\x07\x00\x00\x00\x00" > "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	echo
}

disable_startup_chime 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
