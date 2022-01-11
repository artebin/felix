#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

fix_pulse_audio_no_sound_after_suspend(){
	cd ${BASEDIR}
	
	# See <https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#No_sound_after_resume_from_suspend>
	
	echo "Fixing PulseAudio no sound after suspend ..."
	SERVICE_FILE="fix_pulse_audio_no_sound_after_suspend.service"
	if [ -f /etc/systemd/system/"${SERVICE_FILE}" ]; then
		rm -f /etc/systemd/system/"${SERVICE_FILE}"
	fi
	cp "${SERVICE_FILE}" /etc/systemd/system/"${SERVICE_FILE}"
	systemctl enable "${SERVICE_FILE}"
	
	echo
}

cd ${BASEDIR}

fix_pulse_audio_no_sound_after_suspend 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
