# Debian 11

## Fix the PATH for users and root
$su -
Edit `/etc/login.defs`, `/etc/bash.bashrc` and `/etc/profile`.
$apt-get install sudo
$usermod -aG sudo njames

## Configure apt sources
Add the sections "contrib non-free".

## Python2 cleanup in Debian11
<https://unix.stackexchange.com/questions/609572/debian-bullseye-apt-full-upgrade-removes-whole-lot-of-packages>

## Todos
- switch to PHP7.4 in recipe configure_php_in_userdir
