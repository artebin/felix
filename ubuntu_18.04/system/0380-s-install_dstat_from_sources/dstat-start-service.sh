#!/usr/bin/env bash

PID_FILE="/run/dstat-service.pid"
LOG_DIRECTORY="/var/log/dstat"

if [ ! -d "${LOG_DIRECTORY}" ]; then
	mkdir "${LOG_DIRECTORY}"
fi

cd "${LOG_DIRECTORY}"

# Global system information
dstat --nocolor --output "${LOG_DIRECTORY}"/global.csv --time --cpu --mem --disk --proc --proc-count >/dev/null 2>&1 &
echo "$!" >> "${PID_FILE}"

# I/O
dstat --nocolor --output "${LOG_DIRECTORY}"/io.csv --time --io --fs --swap --disk --disk-util --disk-tps --net -N lo,enp3s0,total --socket --tcp --udp >/dev/null 2>&1 &
echo "$!" >> "${PID_FILE}"

# Top processes
dstat --nocolor --output "${LOG_DIRECTORY}"/top.csv --time --top-cpu-adv --top-mem --top-io-adv --top-bio-adv >/dev/null 2>&1 &
echo "$!" >> "${PID_FILE}"
