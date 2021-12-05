#!/bin/bash

sshuser="null" # SSH user for server
serverip="null" # IP for server
port="null" # SSH port for server
dbpath="null" # Local DB path
serverdbpath="null" # DB path on server 
usbdbpath="null" # DB path on USB device

date
if ! ping -c 1 -4 $serverip >> /dev/null; then echo "Can't ping $serverip" && exit 1; fi
if [ ! $1 ]; then echo -e "Sync server DB: -s or --server\nSync local DB -l or --local" && exit 1; fi
if [ $2 ]; then echo "too many arguments" && exit 1; fi

copytolocal(){
    if ! scp -P $port $sshuser@$serverip:$serverdbpath $dbpath; then echo "SCP failed" && exit 1; fi
    echo "Copy completed, local DB updated"
}

copytoserver(){
    if ! scp -P $port $dbpath $sshuser@$serverip:$serverdbpath; then echo "SCP failed" && exit 1; fi
    echo "Copy completed, server DB updated"
}

case $1 in

    -l | --local) # Update local client DB
        copytolocal
    ;;

    -s | --server) # Update server DB
        copytoserver
    ;;

    *) # Retarded user
        echo -n "Invalid input\nSync server DB: -s or --server\nSync local DB -l or --local"
    ;;
esac

if [ -d "/media/veracrypt1/" ]; then # Default path for Veracrypt devices, change to custom path for custom setup. Folder gets removed after umount from veracrypt device.
    cp $dbpath $usbdbpath
    echo "USB DB Updated"
else echo "USB Not Mounted."; fi
