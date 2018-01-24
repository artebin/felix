#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

USER_NAME="frogstar"
VM_DIRECTORY_PATH=""
VM_NAME=$(basedir ${VM_DIRECTORY_PATH})
VM_SERVICE_FILE_NAME="virtualbox-${VM_NAME}.service"

virtualbox_vm_custom_systemd_service(){
	cd ${BASEDIR}
	
	echo "VirtualBox VM custom systemd service ..."
	
	# Create user and copy VM files
	useradd "${USER_NAME}"
	addgroup "${USER_NAME}" vboxusers
	mkdir -p "/home/${USER_NAME}/VMs/"
	cp -R "${VM_DIRECTORY_PATH}" "/home/${USER_NAME}/VMs/"
	chown -R "${USER_NAME}":"${USER_NAME}" "/home/${USER_NAME}"
	
	runuser -l "${USER_NAME}" -c "VBoxManage registervm /home/${USER_NAME}/VMs/${VM_NAME}/${VM_NAME}.vbox"

	# Add systemd service and enable it
	cp "./${VM_SERVICE_FILE_NAME}" "/etc/systemd/system/${VM_SERVICE_FILE_NAME}"
	chmod a+x "/etc/systemd/system/${VM_SERVICE_FILE_NAME}"
	systemctl enable "${VM_SERVICE_FILE_NAME}"
	
	# Retrieve status of the service
	systemctl status virtualbox-frogstar.service
}

cd ${BASEDIR}
virtualbox_vm_custom_systemd_service 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
