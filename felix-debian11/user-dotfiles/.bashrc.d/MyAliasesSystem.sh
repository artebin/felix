#!/usr/bin/env bash

function print_dmi_product_information(){
	sudo -v
	for FILE in /sys/class/dmi/id/product_*; do
		printf "${FILE}:\n"
		FILE_CONTENT=$(sudo cat "${FILE}"|sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g')
		if [[ ! -z "${FILE_CONTENT}" ]]; then
			printf "${FILE_CONTENT}\n" | sed "s/^/  /g"
		else
			printf "  !! empty file\n"
		fi
	done
	printf "\n"
}
alias print_dmi_product_information=print_dmi_product_information
