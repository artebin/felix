#!/usr/bin/env sh

if [ -d "${HOME}/.ssh" ]; then
	HOME_LINK_SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
	if [ ! -S "${HOME_LINK_SSH_AUTH_SOCK}" ]; then
		eval `ssh-agent`
		ln -sf "${SSH_AUTH_SOCK}" "${HOME_LINK_SSH_AUTH_SOCK}"
	fi
	export SSH_AUTH_SOCK="${HOME_LINK_SSH_AUTH_SOCK}"
	ssh-add -l > /dev/null || ssh-add
fi
