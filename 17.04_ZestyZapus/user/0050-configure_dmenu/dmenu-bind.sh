#!/bin/bash
exe=`dmenu_run -p '$' -h 34 -b -fn 'Droid Sans Mono-12' -sb '#FCE94F' -sf '#000000' ` && eval "exec $exe"
