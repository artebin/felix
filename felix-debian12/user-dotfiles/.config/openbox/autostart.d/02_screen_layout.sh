#!/usr/bin/env sh

# Clear window layouts saved in a previous login
rm -fr "${HOME}/.config/winlayout"

if [ -f "${HOME}/.screenlayout/MyScreenLayout.sh" ];then
	bash "${HOME}/.screenlayout/MyScreenLayout.sh"
fi
