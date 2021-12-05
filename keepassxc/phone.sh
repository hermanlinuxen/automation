#!/bin/bash
sshuser="null" # SSH user on server
serverip="10.0.0.foo" # IP for server
port="null" # SSH port on server
dbpath="null" # DB path on phone
serverdbpath="null" # DB path on server

if ! ping -c 1 $serverip >> /dev/null; then echo "Can't ping $serverip" && exit 1; fi
if ! scp -P $port $sshuser@$serverip:$serverdbpath $dbpath; then echo "SCP failed" && exit 1; fi
echo "Copy completed, local DB updated"
exit 0
