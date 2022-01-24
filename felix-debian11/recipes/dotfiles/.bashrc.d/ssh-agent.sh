#!/usr/bin/env bash

#if [ -z "$SSH_AUTH_SOCK" ] ; then
#	eval `ssh-agent -s`
#	ssh-add
#fi
#trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0

# Using <https://unix.stackexchange.com/a/217223/169557>
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
	eval `ssh-agent`
	ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

