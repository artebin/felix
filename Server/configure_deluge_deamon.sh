#!/bin/sh

cd /home/deluge
deluged -c /home/deluge/.config/deluge
deluge-console "config -s allow_remote True"
deluge-console "config allow_remote"
mkdir deluge.uncompleted
mkdir deluge.completed
mkdir deluge.torrent
killall deluged
