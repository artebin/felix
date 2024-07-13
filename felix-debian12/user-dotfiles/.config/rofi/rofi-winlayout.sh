#!/usr/bin/env bash

#rofi -show winlayout -modi winlayout:"bash ${HOME}/.config/rofi/rofi-winlayout.sh"

function print_rofi_menu(){
	echo -e "\0prompt\x1fload winlayout"
	find "${HOME}/.config/winlayout" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

if [[ "${ROFI_RETV}" -eq 0 ]]; then
	print_rofi_menu
elif [[ "${ROFI_RETV}" -eq 1 ]]; then
	coproc ( winlayout -l "${1}" >/dev/null 2>&1 )
fi
