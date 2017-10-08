#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

copy_themes(){
  cd ${BASEDIR}
  echo "Copying themes ..."
  tar xzf Erthe-njames.tar.gz
  cp -R Erthe-njames /usr/share/themes
  cd /usr/share/themes
  chmod -R go+r ./Erthe-njames
  find ./Erthe-njames -type d | xargs chmod go+x
  
  # Cleanup
  cd ${BASEDIR}
  rm -fr Erthe-njames
}

cd ${BASEDIR}
copy_themes 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
