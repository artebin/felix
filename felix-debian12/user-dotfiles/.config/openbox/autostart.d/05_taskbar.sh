#!/usr/bin/env sh

bash ~/.config/tint2/toggle_tint2.sh -r &
bash ~/scripts/fdpowermon_run.sh &
nm-applet &
bash ~/scripts/pasystray_run.sh &
blueman-applet &
