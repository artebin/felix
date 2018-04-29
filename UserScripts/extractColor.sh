#!/bin/bash

for i in {0..257}; do
	printf "%-15s" "Color#${i}: "
	printf "\e[48;5;${i}m    \e[0m"
	echo
done
echo
