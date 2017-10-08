#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

configure_grub(){
  cd ${BASEDIR}
  echo "Configuring grub ..."
  # Remove hidden timeout 0 => show grub
  sed -i '/^GRUB_HIDDEN_TIMEOUT/s/.*/#GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
  # Remove boot option "quiet" and "splash"
  sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
  update-grub
}

cd ${BASEDIR}
configure_grub 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
