#!/usr/bin/env sh

# Remove all window layouts saved during a previous login
rm -fr "${HOME}/.config/winlayout"

if [ -f "${HOME}/.screenlayout/MyScreenLayout.sh" ];then
	bash "${HOME}/.screenlayout/MyScreenLayout.sh"
fi
