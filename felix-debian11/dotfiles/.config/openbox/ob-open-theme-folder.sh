#!/usr/bin/env bash

OPENBOX_RC_FILE="${HOME}/.config/openbox/rc.xml"

if [[ ! -f "${OPENBOX_RC_FILE}" ]]; then
	ERROR_DIALOG_TEXT="Cannot find OPENB
	OX_RC_FILE[${OPENBOX_RC_FILE}]"
	printf "%s\n" "${ERROR_DIALOG_TEXT}"
	zenity --error --text="${ERROR_DIALOG_TEXT}" --title='Error'
	exit 1
fi

OPENBOX_THEME_NAME=$(xmlstarlet sel -N a="http://openbox.org/3.4/rc" -t -m '/a:openbox_config/a:theme/a:name' -v . -n "${HOME}/.config/openbox/rc.xml")

if [[ -z "${OPENBOX_THEME_NAME}" ]]; then
	ERROR_DIALOG_TEXT="Cannot find OPENBOX_THEME_NAME from OPENBOX_RC_FILE[${OPENBOX_RC_FILE}]"
	printf "%s\n" "${ERROR_DIALOG_TEXT}"
	zenity ---error --text="${ERROR_DIALOG_TEXT}" --title='Error'
	exit 1
fi

# Openbox themes can be located in ~/.local/share/themes, ~/.themes or /usr/share/themes
# See <http://openbox.org/wiki/Help:Themes>
# We search in order over '~/.local/share/themes' > '~/.themes' > '/usr/share/themes'

USER_LOCAL_SHARE_THEMES_DIRECTORY="${HOME}/.local/share/themes"
USER_THEMES_DIRECTORY="${HOME}/.themes"
SYSTEM_USR_SHARE_THEMES_DIRECTORY="/usr/share/themes"

if [[ -d "${USER_LOCAL_SHARE_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}" ]]; then
	xdg-open "${USER_LOCAL_SHARE_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}"
elif [[ -d "${USER_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}" ]]; then
	xdg-open "${USER_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}"
elif [[ -d "${SYSTEM_USR_SHARE_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}" ]]; then
	xdg-open "${SYSTEM_USR_SHARE_THEMES_DIRECTORY}/${OPENBOX_THEME_NAME}"
else
	zenity --error --text="Cannot find OPENBOX_THEME_NAME[${OPENBOX_THEME_NAME}] in Openbox themes folders" --title='Error'
fi
