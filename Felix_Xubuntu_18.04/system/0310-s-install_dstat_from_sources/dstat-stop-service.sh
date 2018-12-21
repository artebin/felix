#!/usr/bin/env bash

PID_FILE="/run/dstat-service.pid"

while IFS= read -r LINE; do
	kill -9 "${LINE}"
done < "${PID_FILE}"

rm -f "${PID_FILE}"
