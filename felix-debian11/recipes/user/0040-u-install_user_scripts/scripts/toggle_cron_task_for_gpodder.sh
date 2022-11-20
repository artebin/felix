#!/usr/bin/env bash

crontab -l > crontab.tmp
grep "gpo update && gpo download" crontab.tmp
GREP_EXIT_CODE="${?}"
if [[ "${GREP_EXIT_CODE}" != 0 ]]; then
	printf "0 * * * * gpo update && gpo download\n" >>crontab.tmp
else
	sed -i '/gpo update && gpo download/d' crontab.tmp
fi
crontab crontab.tmp
rm -f crontab.tmp
