#!/bin/sh

. $(dirname $0)/functions.sh
settitle

caja sftp://$ssh_username:$password@$server 

