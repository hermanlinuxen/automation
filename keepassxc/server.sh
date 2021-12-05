#!/bin/bash

sshuser="null" # SSH user on client
port="null" # SSH port on client
clientdbpath="null" # DB path on client
serverdbpath="null" # DB path on local server
clients=("10.0.0.foo" "10.0.0.bar") # Add clients to sync

date # For better log reading or something
for i in ${clients[@]}; do
    if ! ping -c 1 -4 $i >> /dev/null; then echo "Can't ping $i" && exit 1; fi
    if ! scp -P $port $serverdbpath $sshuser@$i:$clientdbpath; then echo "SCP failed for $i" && exit 1; fi
    echo "Copy completed, DB updated for $i"
done
