#!/usr/bin/env bash

if [[ ! -d "${HOME}/.ssh" ]]; then
	exit 0
fi

# Using <https://unix.stackexchange.com/a/217223/169557>
if [[ ! -S ~/.ssh/ssh_auth_sock ]]; then
	eval `ssh-agent`
	ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

