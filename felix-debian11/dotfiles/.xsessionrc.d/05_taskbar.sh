#!/usr/bin/env bash

tint2 &
bash ~/scripts/fdpowermon_run.sh &
nm-applet &
pasystray --notify=sink_default --notify=source_default &
blueman-applet &
