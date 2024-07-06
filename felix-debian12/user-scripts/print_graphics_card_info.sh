#!/usr/bin/env bash

printf "#### Video card model:\n"
lspci -k | grep -EA3 -i '(vga|3d|display)'

printf "\n"

printf "#### Driver and rendering activation:\n"
glxinfo | grep -Ei '(direct rendering|opengl vendor|opengl renderer|opengl version)'
