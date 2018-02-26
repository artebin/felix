#/bin/bash

# This will wait one second and then steal focus and make the Zenity dialog box always-on-top (aka. 'above').
(sleep 1 && wmctrl -F -a "${1}" -b add,above) &
DIALOG_RETURN_CODE=$(zenity --question --title="${1}" --text "${2}"; echo $?)
if [ ${DIALOG_RETURN_CODE} = 0 ]; then
	exec ${2}
fi
