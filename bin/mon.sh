#!/bin/bash -l

folder=$1
log=/tmp/${folder,/,}.log

echo Mon start script with arg "'$1'" >> $log

if [ -z "$1" ]; then
   exit 1
fi

echo Run monitor for folder "$folder" >> $log

sudo mkdir -p $folder
sudo chmod 777 $folder

while true; do
   if [ -z "$(ls $folder 2>/dev/null)" ]; then
      echo Try mounting "$folder" ...  >> $log
      sudo umount -l $folder
      eval $(ssh-agent)
      ssh-add >> $log 2>&1
      sshfs -p 222 apache@packages.altlinux.org:$folder/ $folder -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 >> $log 2>&1
   fi
   sleep 1
done
