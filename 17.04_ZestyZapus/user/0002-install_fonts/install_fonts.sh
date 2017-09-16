#!/bin/bash

. ../../common.sh
check_shell

copy_additional_fonts(){
  cd ${BASEDIR}
  echo "Copying additonal fonts ..."
  sudo cp *.ttf /usr/local/share/fonts/
  echo "Updating font cache ..."
  sudo fc-cache -f -v 1>/dev/null
}

${BASEDIR}
copy_additional_fonts 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
