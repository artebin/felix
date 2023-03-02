#!/usr/bin/env bash

bash ~/.config/tint2/toggle_tint2.sh -r &
bash ~/scripts/fdpowermon_run.sh &
nm-applet &
pasystray --notify=sink_default --notify=source_default &
blueman-applet &
