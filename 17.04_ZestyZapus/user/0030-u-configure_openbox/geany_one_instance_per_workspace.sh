#!/bin/bash
CURRENT_DESKTOP=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
geany --socket-file=/tmp/geany-sock-${CURRENT_DESKTOP} ${1+"$@"}
