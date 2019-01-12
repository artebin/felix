#!/usr/bin/env bash

source ../../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

disable_startup_chime(){
	cd ${BASEDIR}
	
	echo "Disabling startup chime ..."
	
	# See <https://linux-tips.com/t/disable-startup-sound-of-macbook-and-imac/606/2>
	
	SYSTEM_AUDIO_VOLUME_PATH="/sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82"
	
	if [[ ! -f "${SYSTEM_AUDIO_VOLUME_PATH}" ]]; then
		echo "Cannot find variable at path: ${SYSTEM_AUDIO_VOLUME_PATH}"
		exit 1
	fi
	
	# Some are immutable are in /sys/firware/efi/efivars notably 'SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82'
	# See <https://www.linuxtechi.com/file-directory-attributes-in-linux-using-chattr-lsattr-command>
	lsattr /sys/firmware/efi/efivars
	chattr -i "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	printf "\x07\x00\x00\x00\x00" > "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	echo
}

cd ${BASEDIR}

disable_startup_chime 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
