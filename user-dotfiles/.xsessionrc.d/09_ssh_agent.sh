#!/usr/bin/env sh

if [ -d "${HOME}/.ssh" ]; then
	HOME_LINK_SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
	if [ ! -S "${HOME_LINK_SSH_AUTH_SOCK}" ]; then
		eval `ssh-agent /usr/bin/dbus-launch --exit-with-session x-session-manager`
	fi
	ssh-add -l > /dev/null | ssh-add
fi
