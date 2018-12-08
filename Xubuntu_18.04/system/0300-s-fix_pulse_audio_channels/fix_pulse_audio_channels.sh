#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

fix_pulse_audio_channels(){
	cd ${BASEDIR}
	
	# See <https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#ALSA_channels_mute_when_headphones_are_plugged/unplugged_improperly>
	
	echo "Fixing PulseAudio channels messed up after logout/login ..."
	backup_file copy /etc/pulse/default.pa
	sed -i "s/^load-module module-switch-on-port-available/#load-module module-switch-on-port-available/g" /etc/pulse/default.pa
	
	echo
}

cd ${BASEDIR}
fix_pulse_audio_channels 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
