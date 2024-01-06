#!/usr/bin/env bash

function add_or_update_line_based_on_prefix(){
	PREFIX_TO_SEARCH="${1}"
	LINE_REPLACEMENT_VALUE="${2}"
	FILE_PATH="${3}"
	if grep -q -E "^${PREFIX_TO_SEARCH}" "${FILE_PATH}"; then
		ESCAPED_PREFIX_TO_SEARCH=$(escape_sed_pattern "${PREFIX_TO_SEARCH}")
		ESCAPED_LINE_REPLACEMENT_VALUE=$(escape_sed_pattern "${LINE_REPLACEMENT_VALUE}")
		sed -i "/^${ESCAPED_PREFIX_TO_SEARCH}/s/.*/${ESCAPED_LINE_REPLACEMENT_VALUE}/" "${FILE_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${FILE_PATH}"
	fi
}

function escape_sed_pattern(){
	echo "${1}" | sed -e 's/[\\&]/\\&/g' | sed -e 's/[\/&]/\\&/g'
}

GTK_BOOKMARKS_FILE="${HOME}/.gtk-bookmarks"

########################################
# Push GTK bookmarks to QtProject.conf
########################################
QT_PROJECT_CONF_FILE="${HOME}/.config/QtProject.conf"
QT_PROJECT_CONF_SHORTCUTS_LINE="shortcuts=file:, file://${HOME}"
while IFS= read -r LINE; do
	BOOKMARK_PATH="$(echo "${LINE}" | cut -d ' ' -f 1)"
	QT_PROJECT_CONF_SHORTCUTS_LINE+=", ${BOOKMARK_PATH}"
done < "${GTK_BOOKMARKS_FILE}"
add_or_update_line_based_on_prefix "shortcuts=" "${QT_PROJECT_CONF_SHORTCUTS_LINE}" "${QT_PROJECT_CONF_FILE}"

################################################
# Push GTK bookmarks to KDE user-places.xbel
# This has not been tested and might not work!
################################################
KDE_USER_PLACES_XBEL_FILE="${HOME}/.local/share/user-places.xbel"

cat >"${KDE_USER_PLACES_XBEL_FILE}.tmp" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<xbel xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks" xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info" xmlns:kdepriv="http://www.kde.org/kdepriv">
EOF

while IFS= read -r LINE; do
	BOOKMARK_PATH="$(echo "${LINE}" | cut -d ' ' -f 1)"
	BOOKMARK_NAME="$(echo "${LINE}" | cut -d ' ' -f 2-)"
	cat >>"${KDE_USER_PLACES_XBEL_FILE}.tmp" << EOF
<bookmark href="${BOOKMARK_PATH}">
<title>${BOOKMARK_NAME}</title>
</bookmark>
EOF
done < "${GTK_BOOKMARKS_FILE}"

echo "</xbel>" >>"${KDE_USER_PLACES_XBEL_FILE}.tmp"

if [[ -f "${KDE_USER_PLACES_XBEL_FILE}" ]]; then
	mv "${KDE_USER_PLACES_XBEL_FILE}" "${KDE_USER_PLACES_XBEL_FILE}.$(date +"%Y-%m-%dT%H-%M-%S").bak"
fi
mv "${KDE_USER_PLACES_XBEL_FILE}.tmp" "${KDE_USER_PLACES_XBEL_FILE}"
