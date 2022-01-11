#!/bin/bash

for ESCAPE_SEQUENCE_INDEX in {0..257}; do
	printf "%-15s" "Color [ ${ESCAPE_SEQUENCE_INDEX} ]"
	printf " [\e[48;5;${ESCAPE_SEQUENCE_INDEX}m%-15s\e[0m]" " "
	printf " %-15s" "RGB [ ]"
	echo
done
echo
