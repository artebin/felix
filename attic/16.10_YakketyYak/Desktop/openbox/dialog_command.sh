#/bin/bash

DIALOG_RETURN_CODE=$(zenity --question --text "${1}"; echo $?)
if [ ${DIALOG_RETURN_CODE} = 0 ]; then
  exec ${2}
fi
